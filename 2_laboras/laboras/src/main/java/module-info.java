module com.example.laboras {
    requires javafx.controls;
    requires javafx.fxml;
    requires org.apache.poi.poi;

    requires org.controlsfx.controls;

    opens com.example.laboras to javafx.fxml;
    exports com.example.laboras;

    exports calculator.com.example;
    opens calculator.com.example;
}