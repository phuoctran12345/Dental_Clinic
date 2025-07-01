package model;

public class NotificationTemplate {
    private int templateId;
    private String type;
    private String titleTemplate;
    private String contentTemplate;
    private boolean isActive;

    public NotificationTemplate() {
        this.isActive = true;
    }

    // Getters and Setters
    public int getTemplateId() {
        return templateId;
    }

    public void setTemplateId(int templateId) {
        this.templateId = templateId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTitleTemplate() {
        return titleTemplate;
    }

    public void setTitleTemplate(String titleTemplate) {
        this.titleTemplate = titleTemplate;
    }

    public String getContentTemplate() {
        return contentTemplate;
    }

    public void setContentTemplate(String contentTemplate) {
        this.contentTemplate = contentTemplate;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    @Override
    public String toString() {
        return "NotificationTemplate{" +
                "templateId=" + templateId +
                ", type='" + type + '\'' +
                ", titleTemplate='" + titleTemplate + '\'' +
                ", contentTemplate='" + contentTemplate + '\'' +
                ", isActive=" + isActive +
                '}';
    }
} 