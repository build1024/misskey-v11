<template>
<div class="fquwcbxs">
	<transition name="back">
		<div class="backdrop"
			v-if="isOpen"
			@click="$parent.isDrawerOpening = false"
			@touchstart="$parent.isDrawerOpening = false"
		></div>
	</transition>
	<transition name="nav">
		<div class="body" :class="{ notifications: showNotifications }" v-if="isOpen">
			<div class="nav" v-show="!showNotifications">
				<router-link class="me" v-if="$store.getters.isSignedIn" :to="`/@${$store.state.i.username}`">
					<img class="avatar" :src="$store.state.i.avatarUrl" alt="avatar"/>
					<p class="name"><mk-user-name :user="$store.state.i"/></p>
				</router-link>
				<div class="links">
					<ul>
						<li><router-link to="/" :data-active="$route.name == 'index'"><i><fa icon="home" fixed-width/></i>{{ $t('timeline') }}<i><fa icon="angle-right"/></i></router-link></li>
						<li v-if="$store.state.device.enableMobileQuickNotificationView"><p @click="showNotifications = true"><i><fa :icon="faBell" fixed-width/></i>{{ $t('notifications') }}<i v-if="hasUnreadNotification" class="circle"><fa icon="circle"/></i><i><fa icon="angle-right"/></i></p></li>
						<li v-else><router-link to="/i/notifications" :data-active="$route.name == 'notifications'"><i><fa :icon="faBell" fixed-width/></i>{{ $t('notifications') }}<i v-if="hasUnreadNotification" class="circle"><fa icon="circle"/></i><i><fa icon="angle-right"/></i></router-link></li>
						<li><router-link to="/i/messaging" :data-active="$route.name == 'messaging'"><i><fa :icon="['far', 'comments']" fixed-width/></i>{{ $t('@.messaging') }}<i v-if="hasUnreadMessagingMessage" class="circle"><fa icon="circle"/></i><i><fa icon="angle-right"/></i></router-link></li>
						<li v-if="$store.getters.isSignedIn && ($store.state.i.isLocked || $store.state.i.carefulBot)"><router-link to="/i/follow-requests" :data-active="$route.name == 'follow-requests'"><i><fa :icon="['far', 'envelope']" fixed-width/></i>{{ $t('follow-requests') }}<i v-if="$store.getters.isSignedIn && $store.state.i.pendingReceivedFollowRequestsCount" class="circle"><fa icon="circle"/></i><i><fa icon="angle-right"/></i></router-link></li>
						<li><router-link to="/featured" :data-active="$route.name == 'featured'"><i><fa :icon="faNewspaper" fixed-width/></i>{{ $t('@.featured-notes') }}<i><fa icon="angle-right"/></i></router-link></li>
						<li><router-link to="/explore" :data-active="$route.name == 'explore' || $route.name == 'explore-tag'"><i><fa :icon="faHashtag" fixed-width/></i>{{ $t('@.explore') }}<i><fa icon="angle-right"/></i></router-link></li>
					</ul>
					<ul>
						<li><router-link to="/i/widgets" :data-active="$route.name == 'widgets'"><i><fa :icon="['far', 'calendar-alt']" fixed-width/></i>{{ $t('widgets') }}<i><fa icon="angle-right"/></i></router-link></li>
						<li><router-link to="/i/favorites" :data-active="$route.name == 'favorites'"><i><fa icon="star" fixed-width/></i>{{ $t('@.favorites') }}<i><fa icon="angle-right"/></i></router-link></li>
						<li><router-link to="/i/lists" :data-active="$route.name == 'user-lists'"><i><fa icon="list" fixed-width/></i>{{ $t('user-lists') }}<i><fa icon="angle-right"/></i></router-link></li>
						<li><router-link to="/i/groups" :data-active="$route.name == 'user-groups'"><i><fa :icon="faUsers" fixed-width/></i>{{ $t('user-groups') }}<i><fa icon="angle-right"/></i></router-link></li>
						<li><router-link to="/i/drive" :data-active="$route.name == 'drive'"><i><fa icon="cloud" fixed-width/></i>{{ $t('@.drive') }}<i><fa icon="angle-right"/></i></router-link></li>
						<li><router-link to="/i/pages" :data-active="$route.name == 'pages'"><i><fa :icon="faStickyNote" fixed-width/></i>{{ $t('@.pages') }}<i><fa icon="angle-right"/></i></router-link></li>
					</ul>
					<ul>
						<li><a @click="search"><i><fa icon="search" fixed-width/></i>{{ $t('search') }}<i><fa icon="angle-right"/></i></a></li>
						<li><router-link to="/i/settings" :data-active="$route.name == 'settings'"><i><fa icon="cog" fixed-width/></i>{{ $t('@.settings') }}<i><fa icon="angle-right"/></i></router-link></li>
						<li v-if="$store.getters.isSignedIn && ($store.state.i.isAdmin || $store.state.i.isModerator)"><a href="/admin"><i><fa icon="terminal" fixed-width/></i><span>{{ $t('admin') }}</span><i><fa icon="angle-right"/></i></a></li>
					</ul>
					<ul>
						<li @click="toggleDeckMode"><p><i><fa :icon="$store.state.device.inDeckMode ? faHome : faColumns" fixed-width/></i><span>{{ $store.state.device.inDeckMode ? $t('@.home') : $t('@.deck') }}</span></p></li>
						<li @click="dark"><p><i><fa :icon="$store.state.device.darkmode ? faSun : faMoon" fixed-width/></i><span>{{ $store.state.device.darkmode ? $t('@.turn-off-darkmode') : $t('@.turn-on-darkmode') }}</span></p></li>
					</ul>
				</div>
				<div class="announcements" v-if="announcements && announcements.length > 0">
					<article v-for="announcement in announcements">
						<span v-html="announcement.title" class="title"></span>
						<div><mfm :text="announcement.text"/></div>
						<img v-if="announcement.image" :src="announcement.image" alt="" style="display: block; max-height: 120px; max-width: 100%;"/>
					</article>
				</div>
				<a :href="aboutUrl"><p class="about">{{ $t('about') }}</p></a>
			</div>
			<div class="notifications" v-if="showNotifications">
				<header>
					<button @click="showNotifications = false"><fa icon="times"/></button>
					<i v-if="hasUnreadNotification" class="circle"><fa icon="circle"/></i>
				</header>
				<mk-notifications/>
			</div>
		</div>
	</transition>
</div>
</template>

<script lang="ts">
import Vue from 'vue';
import i18n from '../../../i18n';
import { lang } from '../../../config';
import { faNewspaper, faHashtag, faHome, faColumns, faUsers } from '@fortawesome/free-solid-svg-icons';
import { faMoon, faSun, faStickyNote, faBell } from '@fortawesome/free-regular-svg-icons';
import { search } from '../../../common/scripts/search';

export default Vue.extend({
	i18n: i18n('mobile/views/components/ui.nav.vue'),

	props: ['isOpen'],

	provide: {
		narrow: true
	},

	data() {
		return {
			connection: null,
			aboutUrl: `/docs/${lang}/about`,
			announcements: [],
			searching: false,
			showNotifications: false,
			faNewspaper, faHashtag, faMoon, faSun, faHome, faColumns, faStickyNote, faUsers, faBell,
		};
	},

	computed: {
		hasUnreadNotification(): boolean {
			return this.$store.getters.isSignedIn && this.$store.state.i.hasUnreadNotification;
		},

		hasUnreadMessagingMessage(): boolean {
			return this.$store.getters.isSignedIn && this.$store.state.i.hasUnreadMessagingMessage;
		}
	},

	watch: {
		isOpen() {
			this.showNotifications = false;
		}
	},

	mounted() {
		this.$root.getMeta().then(meta => {
			this.announcements = meta.announcements;
		});

		if (this.$store.getters.isSignedIn) {
			this.connection = this.$root.stream.useSharedConnection('main');
		}
	},

	beforeDestroy() {
		if (this.$store.getters.isSignedIn) {
			this.connection.dispose();
		}
	},

	methods: {
		search() {
			if (this.searching) return;

			this.$root.dialog({
				title: this.$t('search'),
				input: true
			}).then(async ({ canceled, result: query }) => {
				if (canceled) return;

				this.searching = true;
				search(this, query).finally(() => {
					this.searching = false;
				});
			});
		},

		dark() {
			this.$store.commit('device/set', {
				key: 'darkmode',
				value: !this.$store.state.device.darkmode
			});
		},

		toggleDeckMode() {
			this.$store.commit('device/set', { key: 'deckMode', value: !this.$store.state.device.inDeckMode });
			location.replace('/');
		},
	}
});
</script>

<style lang="stylus" scoped>
.fquwcbxs
	$color = var(--text)

	.backdrop
		position fixed
		top 0
		left 0
		z-index 1025
		width 100%
		height 100%
		background var(--mobileNavBackdrop)

	.body
		position fixed
		top 0
		left 0
		z-index 1026
		width 240px
		height 100%
		overflow auto
		-webkit-overflow-scrolling touch
		background var(--secondary)
		font-size 15px

		&.notifications
			width 330px

		> .notifications
			padding-top 42px

			> header
				position fixed
				top 0
				left 0
				z-index 1000
				width 330px
				line-height 42px
				background var(--secondary)

				> button
					display block
					padding 0 14px
					font-size 20px
					line-height 42px
					color var(--text)

				> i
					position absolute
					top 0
					right 16px
					font-size 12px
					color var(--notificationIndicator)

		> .nav

			> .me
				display block
				margin 0
				padding 16px

				.avatar
					display inline
					max-width 64px
					border-radius 32px
					vertical-align middle

				.name
					display block
					margin 0 16px
					position absolute
					top 0
					left 80px
					padding 0
					width calc(100% - 112px)
					color $color
					line-height 96px
					overflow hidden
					text-overflow ellipsis
					white-space nowrap

			ul
				display block
				margin 16px 0
				padding 0
				list-style none

				&:first-child
					margin-top 0

				&:last-child
					margin-bottom 0

				> li
					display block
					font-size 1em
					line-height 1em

					a, p
						display block
						margin 0
						padding 0 20px
						line-height 3rem
						line-height calc(1rem + 30px)
						color $color
						text-decoration none

						&[data-active]
							color var(--primaryForeground)
							background var(--primary)

							> i:last-child
								color var(--primaryForeground)

						> i:first-child
							margin-right 0.5em
							width 20px
							text-align center

						> i.circle
							margin-left 6px
							font-size 10px
							color var(--notificationIndicator)

						> i:last-child
							position absolute
							top 0
							right 0
							padding 0 20px
							font-size 1.2em
							line-height calc(1rem + 30px)
							color $color
							opacity 0.5

			.announcements
				> article
					background var(--mobileAnnouncement)
					color var(--mobileAnnouncementFg)
					padding 16px
					margin 8px 0
					font-size 12px

					> .title
						font-weight bold

			.about
				margin 0 0 8px 0
				padding 1em 0
				text-align center
				font-size 0.8em
				color $color
				opacity 0.5

.nav-enter-active,
.nav-leave-active {
	opacity: 1;
	transform: translateX(0);
	transition: transform 300ms cubic-bezier(0.23, 1, 0.32, 1), opacity 300ms cubic-bezier(0.23, 1, 0.32, 1);
}
.nav-enter,
.nav-leave-active {
	opacity: 0;
	transform: translateX(-240px);
}

.back-enter-active,
.back-leave-active {
	opacity: 1;
	transition: opacity 300ms cubic-bezier(0.23, 1, 0.32, 1);
}
.back-enter,
.back-leave-active {
	opacity: 0;
}

</style>
