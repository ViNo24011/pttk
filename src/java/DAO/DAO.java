package DAO;

import java.io.IOException;
import java.io.Reader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/** Kết nối JDBC chung. Mỗi DAO có một kết nối, đóng bằng try-with-resources. */
public class DAO implements AutoCloseable {
    private final Connection con;
    private static volatile String configPath;

    public static void configure(String path) { configPath = path; }

    public DAO() throws SQLException {
        String path = System.getProperty("pttk.db.config");
        if (path == null || path.isBlank()) path = System.getenv("PTTK_DB_CONFIG");
        if (path == null || path.isBlank()) path = configPath;
        if (path == null || path.isBlank()) path = "config/database.properties";
        Properties config = new Properties();
        try (Reader reader = Files.newBufferedReader(Path.of(path), StandardCharsets.UTF_8)) {
            config.load(reader);
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (IOException | ClassNotFoundException ex) {
            throw new SQLException("Không đọc được cấu hình MySQL hoặc thiếu JDBC driver.", ex);
        }
        Properties credentials = new Properties();
        credentials.setProperty("user", config.getProperty("db.user", "root"));
        credentials.setProperty("password", config.getProperty("db.password", ""));
        credentials.setProperty("connectTimeout", "5000");
        credentials.setProperty("socketTimeout", "15000");
        con = DriverManager.getConnection(config.getProperty("db.url"), credentials);
    }

    protected Connection connection() { return con; }
    @Override public void close() throws SQLException { con.close(); }
}
