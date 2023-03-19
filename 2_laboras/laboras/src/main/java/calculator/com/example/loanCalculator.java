package calculator.com.example;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.chart.LineChart;
import javafx.scene.chart.NumberAxis;
import javafx.scene.chart.XYChart;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;

import javafx.application.Application;
import javafx.application.Platform;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.property.StringProperty;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.stage.Stage;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import java.io.FileOutputStream;
import java.io.IOException;

import static java.lang.Math.floor;
//import static org.apache.poi.ss.formula.functions.MathX.roundDown;

public class loanCalculator {

    public TableView<RowData> table = new TableView<>();
    private loanEntry input;
    private ObservableList<RowData> list = FXCollections.observableArrayList();

    public loanCalculator(loanEntry input, TableView<RowData> table)
    {
        this.input = input;
        this.table = table;
    }

    public void createList()
    {
        if(input.status) {
            list.clear();
            if (input.hasDelay) {
                //int n = input.givenTime -(input.givenTime - (input.a_metai * 12 + input.a_men));
                for (int i = 0; i < input.a_terminas; i++) {
                    float palukanos = input.a_procentas / 100 / 12 * input.paskola;
                    palukanos = roundDown(palukanos);
                    input.startDate = i;
                    float sumoketa = 0;
                    String data = input.startDate + "";
                    if (input.hasFilter) {
                        if (i > input.f_men0 && i < input.f_men1) {
                            list.add(new RowData(data, palukanos, palukanos, input.paskola, sumoketa));
                        }
                    } else {
                        list.add(new RowData(data, palukanos, palukanos, input.paskola, sumoketa));
                    }
                    //input.paskola = input.paskola - palukanos;
                    input.startDate += 1;
                }
            }
            if (input.isAnuitetas) {
                //int procentas = input.procentas / 12 / 100;
                //int n = input.givenTime;
                float sumoketa = 0;
                for (int i = 0; i < input.givenTime; i++) {
                    float paskola = (float) ((input.paskola * input.procentas / 12 / 100) / (1 - (1 / Math.pow(1 + (input.procentas / 12 / 100), input.givenTime))));
                    paskola = roundDown(paskola);
                    float palukanos = input.paskola * input.procentas / 12 / 100;
                    sumoketa = sumoketa + paskola + palukanos;
                    palukanos = (float) roundDown(palukanos);
                    String data = input.startDate+i + "";

                    if (input.hasFilter) {
                        if (i > input.f_men0 && i < input.f_men1) {
                            list.add(new RowData(data, paskola + palukanos, palukanos, input.paskola, sumoketa));
                        }
                    } else {
                        list.add(new RowData(data, paskola + palukanos, palukanos, input.paskola, sumoketa));
                    }
                    input.paskola -= paskola - palukanos;
                    input.paskola = roundDown(input.paskola);
                }
            } else {
                float paskola = input.paskola / input.givenTime;
                float sumoketa = 0;
                paskola = roundDown(paskola);
                for (int i = 0; i < input.givenTime; i++) {
                    float palukanos = input.paskola * input.procentas / 100 / 12;
                    sumoketa = sumoketa + paskola + palukanos;
                    palukanos = roundDown(palukanos);
                    String data = input.startDate+i + "";;

                    if (input.hasFilter) {
                        if (i > input.f_men0 && i < input.f_men1) {
                            list.add(new RowData(data, paskola + palukanos, palukanos, input.paskola, sumoketa));
                        }
                    } else {
                        list.add(new RowData(data, paskola + palukanos, palukanos, input.paskola, sumoketa));
                    }
                    input.paskola -= paskola;
                }
            }
        }
    }
    public static float roundDown(float f) {
        return (float) (Math.floor(f * 100)/100);
    }

    public void createTable(){

        table.getColumns().clear();

        TableColumn<RowData, String> dataColumn = new TableColumn<>("Data");
        dataColumn.setCellValueFactory(new PropertyValueFactory<RowData, String>("data"));

        TableColumn<RowData, Float> imokaColumn = new TableColumn<>("Imoka");
        imokaColumn.setCellValueFactory(new PropertyValueFactory<RowData, Float>("imoka"));

        TableColumn<RowData, Float> palukanosColumn = new TableColumn<>("Palukanos");
        palukanosColumn.setCellValueFactory(new PropertyValueFactory<RowData, Float>("palukanos"));

        TableColumn<RowData, Float> likutisColumn = new TableColumn<>("Likutis");
        likutisColumn.setCellValueFactory(new PropertyValueFactory<RowData, Float>("likutis"));

        TableColumn<RowData, Float> sumoketaColumn = new TableColumn<>("Sumoketa");
        sumoketaColumn.setCellValueFactory(new PropertyValueFactory<RowData, Float>("sumoketa"));

        table.getColumns().addAll(dataColumn, imokaColumn, palukanosColumn, likutisColumn, sumoketaColumn);
        table.setItems(list);

    }

    public void excelTable ()
    {
        Workbook workbook = new HSSFWorkbook();
        Sheet spreadsheet = workbook.createSheet("book1");

        Row row = spreadsheet.createRow(0);

        for (int i = 0; i < table.getColumns().size(); i++) {
            row.createCell(i).setCellValue(table.getColumns().get(i).getText());
        }

        for (int i = 0; i < table.getItems().size(); i++) {
            row = spreadsheet.createRow(i + 1);
            for (int j = 0; j < table.getColumns().size(); j++) {
                if (table.getColumns().get(j).getCellData(i) != null) {
                    row.createCell(j).setCellValue(table.getColumns().get(j).getCellData(i).toString());
                } else {
                    row.createCell(j).setCellValue("");
                }
            }
        }
        try {
            FileOutputStream fileOut = new FileOutputStream("workbook.xls");
            workbook.write(fileOut);
            fileOut.close();
        } catch(Exception e)
        {
            throw new RuntimeException();
        }
    }

    public void createChart(LineChart<?,?> chart){
        XYChart.Series series = new XYChart.Series<>();

        for (int i=0; i<list.size(); i++) {
            series.getData().add(new XYChart.Data(list.get(i).getData(), list.get(i).getImoka()));
        }

        if (input.isAnuitetas) series.setName("Anuiteto");
        else series.setName("Linijinis");

        chart.getData().addAll(series);
    }
}
