<template>
<div class="root nav-folder"
	:data-draghover="draghover"
	@click="onClick"
	@dragover.prevent.stop="onDragover"
	@dragenter="onDragenter"
	@dragleave="onDragleave"
	@drop.stop="onDrop"
>
	<i v-if="folder == null" class="cloud"><fa icon="cloud"/></i>
	<span>{{ folder == null ? $t('@.drive') : folder.name }}</span>
</div>
</template>

<script lang="ts">
import Vue from 'vue';
import i18n from '../../../i18n';
export default Vue.extend({
	i18n: i18n(),
	props: ['folder'],
	data() {
		return {
			hover: false,
			draghover: false
		};
	},
	computed: {
		browser(): any {
			return this.$parent;
		}
	},
	methods: {
		onClick() {
			this.browser.move(this.folder);
		},
		onMouseover() {
			this.hover = true;
		},
		onMouseout() {
			this.hover = false;
		},
		onDragover(e) {
			// このフォルダがルートかつカレントディレクトリならドロップ禁止
			if (this.folder == null && this.browser.folder == null) {
				e.dataTransfer.dropEffect = 'none';
			}

			const isFile = e.dataTransfer.items[0].kind == 'file';
			const isDriveFile = e.dataTransfer.types.includes('mk_drive_file');
			const isDriveFolder = e.dataTransfer.types.includes('mk_drive_folder');

			if (isFile || isDriveFile || isDriveFolder) {
				e.dataTransfer.dropEffect = e.dataTransfer.effectAllowed == 'all' ? 'copy' : 'move';
			} else {
				e.dataTransfer.dropEffect = 'none';
			}

			return false;
		},
		onDragenter() {
			if (this.folder || this.browser.folder) this.draghover = true;
		},
		onDragleave() {
			if (this.folder || this.browser.folder) this.draghover = false;
		},
		onDrop(e) {
			this.draghover = false;

			// ファイルだったら
			if (e.dataTransfer.files.length > 0) {
				for (const file of Array.from(e.dataTransfer.files)) {
					this.browser.upload(file, this.folder);
				}
				return;
			}

			//#region ドライブのファイル
			const driveFile = e.dataTransfer.getData('mk_drive_file');
			if (driveFile != null && driveFile != '') {
				const file = JSON.parse(driveFile);
				this.browser.removeFile(file.id);
				this.$root.api('drive/files/update', {
					fileId: file.id,
					folderId: this.folder ? this.folder.id : null
				});
			}
			//#endregion

			//#region ドライブのフォルダ
			const driveFolder = e.dataTransfer.getData('mk_drive_folder');
			if (driveFolder != null && driveFolder != '') {
				const folder = JSON.parse(driveFolder);
				// 移動先が自分自身ならreject
				if (this.folder && folder.id == this.folder.id) return;
				this.browser.removeFolder(folder.id);
				this.$root.api('drive/folders/update', {
					folderId: folder.id,
					parentId: this.folder ? this.folder.id : null
				});
			}
			//#endregion
		}
	}
});
</script>

<style lang="stylus" scoped>
.root.nav-folder
	> *
		pointer-events none

	&[data-draghover]
		background #eee

	i.cloud
		margin-right 4px

</style>
