/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

/**
 *
 * @author tranhongphuoc
 */


import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.EventDateTime;

import java.io.FileInputStream;
import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Collections;

public class GoogleCalendarUtil {
    private static final String APPLICATION_NAME = "Dental Clinic API";
    private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
    private static final String CREDENTIALS_FILE_PATH = "src/java/calendar.json";

    public static Calendar getCalendarService() throws IOException, GeneralSecurityException {
        GoogleCredential credential = GoogleCredential.fromStream(new FileInputStream(CREDENTIALS_FILE_PATH))
                .createScoped(Collections.singleton("https://www.googleapis.com/auth/calendar"));
        return new Calendar.Builder(GoogleNetHttpTransport.newTrustedTransport(), JSON_FACTORY, credential)
                .setApplicationName(APPLICATION_NAME)
                .build();
    }

    public static String createEvent(String summary, String description, String startDateTime, String endDateTime) throws Exception {
        Calendar service = getCalendarService();

        Event event = new Event()
                .setSummary(summary)
                .setDescription(description);

        EventDateTime start = new EventDateTime()
                .setDateTime(new com.google.api.client.util.DateTime(startDateTime))
                .setTimeZone("Asia/Ho_Chi_Minh");
        event.setStart(start);

        EventDateTime end = new EventDateTime()
                .setDateTime(new com.google.api.client.util.DateTime(endDateTime))
                .setTimeZone("Asia/Ho_Chi_Minh");
        event.setEnd(end);

        event = service.events().insert("primary", event).execute();
        return event.getHtmlLink();
    }
}