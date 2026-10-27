package karate.support;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;

public final class ApiCleanup {

    private static final int CONNECT_TIMEOUT_MS = 15_000;
    private static final int READ_TIMEOUT_MS = 30_000;

    private ApiCleanup() {
    }

    public static Map<String, Object> restfulBooker(String baseUrl, Object bookingId, String token) {
        if (bookingId == null || token == null || token.trim().isEmpty()) {
            return result(false, null, null, "Falta bookingId o token para limpiar el recurso residual");
        }
        String resourceUrl = trimSlash(baseUrl) + "/booking/" + bookingId;
        Map<String, String> headers = new LinkedHashMap<>();
        headers.put("Cookie", "token=" + token);
        return deleteAndConfirmAbsent(resourceUrl, headers, 201);
    }

    public static Map<String, Object> petStore(String baseUrl, Object petId) {
        if (petId == null) {
            return result(false, null, null, "Falta petId para limpiar el recurso residual");
        }
        String resourceUrl = trimSlash(baseUrl) + "/pet/" + petId;
        return deleteAndConfirmAbsent(resourceUrl, new LinkedHashMap<>(), 200);
    }

    private static Map<String, Object> deleteAndConfirmAbsent(
            String resourceUrl, Map<String, String> headers, int successfulDeleteStatus) {
        try {
            int deleteStatus = request("DELETE", resourceUrl, headers);
            if (deleteStatus == successfulDeleteStatus) {
                return result(true, deleteStatus, null, "Recurso eliminado");
            }
            int getStatus = request("GET", resourceUrl, new LinkedHashMap<>());
            if (getStatus == 404) {
                return result(true, deleteStatus, getStatus, "Recurso ya inexistente");
            }
            return result(false, deleteStatus, getStatus,
                    "El recurso continuó accesible o devolvió un estado inesperado");
        } catch (IOException exception) {
            return result(false, null, null,
                    "Error de conectividad durante la limpieza: " + exception.getClass().getSimpleName());
        }
    }

    private static int request(String method, String address, Map<String, String> headers) throws IOException {
        HttpURLConnection connection = (HttpURLConnection) new URL(address).openConnection();
        connection.setRequestMethod(method);
        connection.setConnectTimeout(CONNECT_TIMEOUT_MS);
        connection.setReadTimeout(READ_TIMEOUT_MS);
        connection.setInstanceFollowRedirects(false);
        connection.setRequestProperty("Accept", "application/json");
        for (Map.Entry<String, String> header : headers.entrySet()) {
            connection.setRequestProperty(header.getKey(), header.getValue());
        }
        int status = connection.getResponseCode();
        consume(connection, status);
        connection.disconnect();
        return status;
    }

    private static void consume(HttpURLConnection connection, int status) {
        try (InputStream stream = status >= 400 ? connection.getErrorStream() : connection.getInputStream()) {
            if (stream != null) {
                byte[] buffer = new byte[512];
                while (stream.read(buffer) != -1) {
                    // Consumir sin registrar cuerpos que pudieran contener datos sensibles.
                }
            }
        } catch (IOException ignored) {
            // El estado HTTP ya fue obtenido; la lectura del cuerpo no altera el resultado.
        }
    }

    private static Map<String, Object> result(
            boolean success, Integer deleteStatus, Integer getStatus, String message) {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", success);
        result.put("deleteStatus", deleteStatus);
        result.put("getStatus", getStatus);
        result.put("message", new String(message.getBytes(StandardCharsets.UTF_8), StandardCharsets.UTF_8));
        return result;
    }

    private static String trimSlash(String value) {
        return value != null && value.endsWith("/") ? value.substring(0, value.length() - 1) : value;
    }
}
