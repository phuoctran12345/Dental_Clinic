package model;

import java.sql.Timestamp;

public class ChatMessage {
    private int senderId;
    private int receiverId;
    private String message;
    private Timestamp timestamp;
    
    public ChatMessage() {}
    
    public ChatMessage(int senderId, int receiverId, String message) {
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.message = message;
        this.timestamp = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and Setters
    public int getSenderId() {
        return senderId;
    }
    
    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }
    
    public int getReceiverId() {
        return receiverId;
    }
    
    public void setReceiverId(int receiverId) {
        this.receiverId = receiverId;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public Timestamp getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }
    
    @Override
    public String toString() {
        return "ChatMessage{" +
                "senderId=" + senderId +
                ", receiverId=" + receiverId +
                ", message='" + message + '\'' +
                ", timestamp=" + timestamp +
                '}';
    }
} 