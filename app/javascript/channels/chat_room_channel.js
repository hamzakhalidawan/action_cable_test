import consumer from "./consumer"

const chatRoomChannel = consumer.subscriptions.create("ChatRoomChannel", {
  connected() {
    console.log("Connected to the chat room!");
  },

  disconnected() {

  },

  received(data) {
    if (data.message) {
      let current_name = sessionStorage.getItem('chat_room_name')
      let msg_class = data.sent_by === current_name ? "sent" : "received"
      $('#messages').append(`<p class='${msg_class}'>` + data.message + '</p>')
      $('#count').text(data.count)
    } else if(data.chat_room_name) {
      let name = data.chat_room_name;
      let announcement_type = data.type == 'join' ? 'joined' : 'left';
      $('#messages').append(`<p class="announce"><em>${name}</em> ${announcement_type} the room</p>`)
      if(data.type == 'join'){
        $('#count').text(data.count)
      }
    }
  },

  speak(message) {
    let name = sessionStorage.getItem('chat_room_name')
    let id = sessionStorage.getItem('id')
    this.perform('speak', { message, name, id })
  },

  announce(content) {
    let id = sessionStorage.getItem('id')
    this.perform('announce', { name: content.name, type: content.type, id: id })
  }
});

export default chatRoomChannel;