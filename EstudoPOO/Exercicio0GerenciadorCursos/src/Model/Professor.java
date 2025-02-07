package Model;

public class Professor extends Pessoa {
    // encapsulamento
    // atributos - privados
    private Double salario;
    // metodos - publicos
    // construtor
    public Professor(String nome, String cpf, Double salario) {
        super(nome, cpf);
        this.salario = salario;
    }
    // getters and setters
    public Double getSalario() {
        return salario;
    }
    public void setSalario(Double salario) {
        this.salario = salario;
    }
    @Override // exibir informações - polimorfismo
    public void exibirInformacoes() {
        super.exibirInformacoes();
        System.out.println("Salario: " + getSalario());
    }
}
