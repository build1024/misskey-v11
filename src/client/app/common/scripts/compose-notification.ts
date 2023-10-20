import getNoteSummary from '../../../../misc/get-note-summary';
import getReactionEmoji from '../../../../misc/get-reaction-emoji';
import getUserName from '../../../../misc/get-user-name';

type Notification = {
	title: string;
	body: string;
	icon: string;
	onclick?: any;
};

// TODO: i18n

export default function(type, data): Notification {
	switch (type) {
		case 'driveFileCreated':
			return {
				title: 'File uploaded',
				body: data.name,
				icon: data.url
			};

		case 'unreadMessagingMessage':
			return {
				title: `New message from ${getUserName(data.user)}`,
				body: data.text, // TODO: getMessagingMessageSummary(data),
				icon: data.user.avatarUrl
			};

		case 'notification':
			const notification = data as any;	// TODO: PackedNotification
			switch (notification.type) {
				case 'follow':
					return {
						title: `Followed by ${getUserName(notification.user)}`,
						body: '',
						icon: notification.user.avatarUrl
					};

				case 'mention':
					return {
						title: `Mention from ${getUserName(notification.user)}`,
						body: getNoteSummary(notification.note),
						icon: notification.user.avatarUrl
					};

				case 'reply':
					return {
						title: `Reply from ${getUserName(notification.user)}`,
						body: getNoteSummary(notification.note),
						icon: notification.user.avatarUrl
					};

				case 'renote':
					return {
						title: `Renoted by ${getUserName(notification.user)}`,
						body: getNoteSummary(notification.note.renote),
						icon: notification.user.avatarUrl
					};

				case 'quote':
					return {
						title: `Quoted by ${getUserName(notification.user)}`,
						body: getNoteSummary(notification.note),
						icon: notification.user.avatarUrl
					};

				case 'reaction':
					return {
						title: `${getReactionEmoji(notification.reaction)} from ${getUserName(notification.user)}`,
						body: getNoteSummary(notification.note),
						icon: notification.user.avatarUrl
					};

				case 'poll_vote':
					return {
						title: `Voted by ${getUserName(notification.user)}`,
						body: getNoteSummary(notification.note),
						icon: notification.user.avatarUrl
					};

				case 'receiveFollowRequest':
					return {
						title: `Follow request from ${getUserName(notification.user)}`,
						body: '',
						icon: notification.user.avatarUrl
					};

				default:
					return {
						title: `${getUserName(notification.user)}`,
						body: notification.type,
						icon: notification.user.avatarUrl
					};
			}

		default:
			return null;
	}
}
