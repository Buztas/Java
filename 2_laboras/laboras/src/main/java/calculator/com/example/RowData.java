package calculator.com.example;

public class RowData
{
    public String data;
    public float imoka, palukanos, likutis, sumoketa;

    public RowData(String data, float imoka, float palukanos, float likutis, float sumoketa)
    {
        this.data = data;
        this.imoka = imoka;
        this.palukanos = palukanos;
        this.likutis = likutis;
        this.sumoketa = sumoketa;
    }

    public float getSumoketa() {
        return sumoketa;
    }

    public void setSumoketa(float sumoketa) {
        this.sumoketa = sumoketa;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public float getImoka() {
        return imoka;
    }

    public void setImoka(float imoka) {
        this.imoka = imoka;
    }

    public float getPalukanos() {
        return palukanos;
    }

    public void setPalukanos(float palukanos) {
        this.palukanos = palukanos;
    }

    public float getLikutis() {
        return likutis;
    }

    public void setLikutis(float likutis) {
        this.likutis = likutis;
    }
}