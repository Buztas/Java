package com.example.laboras;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.chart.LineChart;
import javafx.scene.control.*;
import javafx.scene.text.Text;
import javafx.stage.Stage;

import java.time.Year;
import java.util.Date;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;

import java.io.IOException;
import calculator.com.example.*;

public class HelloController {


    @FXML
    private TextField paskola_id;
    @FXML
    private TextField metai_id;
    @FXML
    private TextField men_id;
    @FXML
    private TextField procentas_id;
    @FXML
    private RadioButton delay_id;
    @FXML
    private Text main_label;
    @FXML
    private TextField metaiAtidejimas;
    @FXML
    private TextField menuoAtidejimas;
    @FXML
    private TextField procentasAtidejimas;
    @FXML
    private Text delayText;
    @FXML
    private TextField f_iki;
    @FXML
    private TextField f_nuo;
    @FXML
    private TableView<RowData> table_id;
    @FXML
    LineChart<?,?> outputChart;
    loanEntry input = new loanEntry();
    loanCalculator data;

    private Stage stage;
    private Scene scene;
    private Parent root;

    public void convert()
    {
        input.status = true;
        try {
            input.paskola = Integer.parseInt(paskola_id.getText());
            input.metai = Integer.parseInt(metai_id.getText());
            input.men = Integer.parseInt(men_id.getText());
            input.procentas = Integer.parseInt(procentas_id.getText());

            input.givenTime = input.metai*12 + input.men;

        } catch( Exception e )
        {
            main_label.setText(" Yra klaidų ");
            input.status = false;
        }
    }

    public void delay()
    {
        input.delay_error = false;
        try {
            input.a_metai = Integer.parseInt(metaiAtidejimas.getText());
            input.a_men = Integer.parseInt(menuoAtidejimas.getText());
            input.a_procentas = Integer.parseInt(procentasAtidejimas.getText());

            input.a_terminas = input.a_metai * 12 + input.a_men;
            input.hasDelay = true;
        } catch(Exception e)
        {
            delayText.setText("Yra klaidų");
            input.hasDelay = false;
            input.delay_error = true;
        }
    }

    public void filtras()
    {
        try {
        input.f_men0 = Integer.parseInt(f_nuo.getText());
        input.f_men1 = Integer.parseInt(f_iki.getText());
        input.hasFilter = true;
        } catch(Exception e)
        {
            System.out.println("Error.");
        }
    }

    public void anuiteto()
    {
        input.isAnuitetas = !input.isAnuitetas;
    }

    public void linear()
    {
        input.isLinijinis = !input.isLinijinis;
    }

    public void printTable()
    {
        data = new loanCalculator(input, table_id);
        data.createList();
        data.createTable();
        data.createChart(outputChart);
    }

    public void submit()
    {
        convert();
        delay();
        filtras();
        printTable();
        if(input.status)
            main_label.setText("Įveskite duomenis:");
        if(!input.delay_error)
            delayText.setText("Veskite atidėjimo duomenis: ");
        System.out.println(input.hasDelay + " ," + input.hasFilter + " , " + input.status);

        //System.out.println(input.paskola + " ," + input.givenTime + " , " + input.procentas);
    }

    public void excel()
    {
        data.excelTable();
    }

    public void clear()
    {
        outputChart.getData().clear();
    }

//    public void works(ActionEvent event) throws IOException
//    {
//        Parent root = FXMLLoader.load(getClass().getResource("grafikai.fxml"));
//        stage = (Stage)((Node)event.getSource()).getScene().getWindow();
//        scene = new Scene(root);
//        stage.setScene(scene);
//        stage.show();
//
//        //data.createChart(outputChart);
//    }
//
//    public void atgal(ActionEvent event) throws IOException
//    {
//        root = FXMLLoader.load(getClass().getResource("hello-view.fxml"));
//        stage = (Stage)((Node)event.getSource()).getScene().getWindow();
//        scene = new Scene(root);
//        stage.setScene(scene);
//        stage.show();
//    }
}