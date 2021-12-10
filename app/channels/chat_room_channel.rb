class ChatRoomChannel < ApplicationCable::Channel
    def subscribed
      stream_from "chat_room_channel"
    end
  
    def unsubscribed
      # Any cleanup needed when channel is unsubscribed
    end
  
    def speak(data)
      if data["id"].present? && data["id"] == "7478"
        @response =  RestClient.post("https://api.s.gymcloud.com/conversations?recipient_id=7478&body=#{data["message"]}", {}, {:authorization => "Bearer 3b103e685e9951b3dcdecd84b3f7811e2a35f723154565d64cc177ef3f740d78" })
      else
        @response =  RestClient.post("https://api.s.gymcloud.com/conversations?recipient_id=7479&body=#{data["message"]}", {}, {:authorization => "Bearer 0ba295f4706e564a6d79db2cfa1006ceea57ed153044a153c7e230d9bee3f90e" })
      end

      if data["id"].present? && data["id"] == "7478"
        count_response =  RestClient.get("https://api.s.gymcloud.com/conversations/count", {:authorization => "Bearer 3b103e685e9951b3dcdecd84b3f7811e2a35f723154565d64cc177ef3f740d78" })
      else
        count_response =  RestClient.get("https://api.s.gymcloud.com/conversations/count", {:authorization => "Bearer 0ba295f4706e564a6d79db2cfa1006ceea57ed153044a153c7e230d9bee3f90e" })
      end
      if count_response
        count_str = JSON.parse count_response
      end
      if @response
        str = JSON.parse @response
        ActionCable.server.broadcast( "chat_room_channel", { message: str['body'], sent_by: data["name"], count: count_str } )
      end
    end
  
    def announce(data)
      if data["id"].present? && data["id"] == "7479"
        count_response =  RestClient.get("https://api.s.gymcloud.com/conversations/count", {:authorization => "Bearer 0ba295f4706e564a6d79db2cfa1006ceea57ed153044a153c7e230d9bee3f90e" })
      else
        count_response =  RestClient.get("https://api.s.gymcloud.com/conversations/count", {:authorization => "Bearer 3b103e685e9951b3dcdecd84b3f7811e2a35f723154565d64cc177ef3f740d78" })
      end
      if count_response
        count_str = JSON.parse count_response
      end
      ActionCable.server.broadcast( "chat_room_channel", { chat_room_name: data["name"], type: data["type"], count: count_str } )
    end
end
