package utils;

// Imports for Jakarta EE equivalents
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.HandshakeResponse;
import jakarta.websocket.server.HandshakeRequest;
import jakarta.websocket.server.ServerEndpointConfig;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

public class GetHttpSessionConfigurator extends ServerEndpointConfig.Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig config, HandshakeRequest request, HandshakeResponse response) {
        // The cast needs to be to jakarta.servlet.http.HttpSession
        HttpSession httpSession = (HttpSession) request.getHttpSession();

        if (httpSession != null) {
            Map<String, Object> httpSessionAttributes = new HashMap<>();

            // Correctly iterating through HttpSession attributes
            Enumeration<String> attributeNames = httpSession.getAttributeNames();
            while (attributeNames.hasMoreElements()) {
                String name = attributeNames.nextElement();
                httpSessionAttributes.put(name, httpSession.getAttribute(name));
            }

            config.getUserProperties().put("httpSessionAttributes", httpSessionAttributes);

            System.out.println("Handshake successful. HTTP Session ID: " + httpSession.getId());

        } else {
            System.err.println("Error: HttpSession is null during WebSocket handshake.");
        }
    }
}