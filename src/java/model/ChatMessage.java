/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Home
 */
public class ChatMessage {

    private int messageId;
    private int userId;
    private int receiverId; 
    private String content;
    private Timestamp timestamp;
    private String senderName;       // Tên người gửi (Doctors/Patients/Users)
    private String receiverName;     // Tên người nhận
    private String senderAvatar;     // Avatar người gửi
    private String receiverAvatar;   // Avatar người nhận
    private String senderRole;
private String receiverRole;

    public ChatMessage() {
    }

    public ChatMessage(int messageId, int userId, int receiverId, String content, Timestamp timestamp, String senderName, String receiverName, String senderAvatar, String receiverAvatar, String senderRole, String receiverRole) {
        this.messageId = messageId;
        this.userId = userId;
        this.receiverId = receiverId;
        this.content = content;
        this.timestamp = timestamp;
        this.senderName = senderName;
        this.receiverName = receiverName;
        this.senderAvatar = senderAvatar;
        this.receiverAvatar = receiverAvatar;
        this.senderRole = senderRole;
        this.receiverRole = receiverRole;
    }

    public int getMessageId() {
        return messageId;
    }

    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(int receiverId) {
        this.receiverId = receiverId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public String getSenderName() {
        return senderName;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getSenderAvatar() {
        return senderAvatar;
    }

    public void setSenderAvatar(String senderAvatar) {
        this.senderAvatar = senderAvatar;
    }

    public String getReceiverAvatar() {
        return receiverAvatar;
    }

    public void setReceiverAvatar(String receiverAvatar) {
        this.receiverAvatar = receiverAvatar;
    }

    public String getSenderRole() {
        return senderRole;
    }

    public void setSenderRole(String senderRole) {
        this.senderRole = senderRole;
    }

    public String getReceiverRole() {
        return receiverRole;
    }

    public void setReceiverRole(String receiverRole) {
        this.receiverRole = receiverRole;
    }

    @Override
    public String toString() {
        return "ChatMessage{" + "messageId=" + messageId + ", userId=" + userId + ", receiverId=" + receiverId + ", content=" + content + ", timestamp=" + timestamp + ", senderName=" + senderName + ", receiverName=" + receiverName + ", senderAvatar=" + senderAvatar + ", receiverAvatar=" + receiverAvatar + ", senderRole=" + senderRole + ", receiverRole=" + receiverRole + '}';
    }


  
    
    
}
