package karate.support;

import com.intuit.karate.http.HttpLogModifier;
import java.util.regex.Pattern;

public final class SensitiveDataLogModifier implements HttpLogModifier {

    private static final String MASK = "***MASKED***";
    private static final Pattern JSON_SECRET = Pattern.compile(
            "(?i)(\\\"(?:username|password|token|authorization|cookie)\\\"\\s*:\\s*\\\")[^\\\"]*(\\\")");
    private static final Pattern FORM_SECRET = Pattern.compile(
            "(?i)((?:username|password|token|authorization|cookie)=)[^&\\s]+" );
    private static final Pattern QUERY_SECRET = Pattern.compile(
            "(?i)((?:username|password|token|authorization|cookie)=)[^&\\s]+" );

    @Override
    public boolean enableForUri(String uri) {
        return true;
    }

    @Override
    public String uri(String uri) {
        return maskText(uri);
    }

    @Override
    public String header(String headerName, String headerValue) {
        if (headerName != null && (headerName.equalsIgnoreCase("Authorization")
                || headerName.equalsIgnoreCase("Cookie")
                || headerName.equalsIgnoreCase("Set-Cookie"))) {
            return MASK;
        }
        return maskText(headerValue);
    }

    @Override
    public String request(String uri, String request) {
        return maskText(request);
    }

    @Override
    public String response(String uri, String response) {
        return maskText(response);
    }

    private static String maskText(String value) {
        if (value == null || value.isEmpty()) {
            return value;
        }
        String masked = JSON_SECRET.matcher(value).replaceAll("$1" + MASK + "$2");
        masked = FORM_SECRET.matcher(masked).replaceAll("$1" + MASK);
        return QUERY_SECRET.matcher(masked).replaceAll("$1" + MASK);
    }
}
