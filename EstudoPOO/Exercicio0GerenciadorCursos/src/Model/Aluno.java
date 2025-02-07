package Model;

public class Aluno extends Pessoa {
    private String matricula;
    private double nota;

    public Aluno(String nome, String cpf, String matricula, double nota) {
        super(nome, cpf);
        this.matricula = matricula;
        this.nota = nota;
    }

    public String getMatricula() {
        return matricula;
    }

    public void setMatricula(String matricula) {
        this.matricula = matricula;
    }

    public double getNota() {
        return nota;
    }

    public void setNota(double nota) {
        this.nota = nota;
    }

    @Override
    public void exibirInformacoes() {
        super.exibirInformacoes();
        System.out.println("Matrícula: " + getMatricula());
        System.out.println("Nota: " + getNota());
    }

    // incluir o metodo avaliarDesempenho
    public void avaliarDesempenho() {
        if (nota >= 6) {
            System.out.println("Aluno Aprovado");
        } else {
            System.out.println("Aluno Reprovado");
        }
    }
}

    