package View;

import Model.Aluno;
import Model.Professor;

import java.util.Scanner;

import Controller.Curso;

public class App {
    public static void main(String[] args) throws Exception {
        // criar curso e incluir Professor
        Professor professor = new Professor("Jose Pereira", "123.456.789-00", 15000.00);
        Curso curso = new Curso("Programação Java", professor);
        // menu de opções
        int operacao;
        boolean continuar = true;
        Scanner sc = new Scanner(System.in);
        while (continuar) {
            System.out.println("==================================");
            System.out.println("Escolha a opção desejada");
            System.out.println("1. Adicionar aluno");
            System.out.println("2. Informações do curso");
            System.out.println("3. Verificar aprovação de aluno");
            System.out.println("4. Sair");
            System.out.println("==================================");
            operacao = sc.nextInt();
            switch (operacao) {
                case 1: // adicionar aluno
                    System.out.println("Informe o nome do aluno");
                    String nomeA = sc.next();
                    System.out.println("Informe o CPF do aluno");
                    String cpfA = sc.next();
                    System.out.println("Informe o número da matrícula");
                    String matriculA = sc.next();
                    System.out.println("Informe a nota do aluno");
                    double notaA = sc.nextDouble();
                    Aluno aluno = new Aluno(nomeA, cpfA, matriculA, notaA);
                    System.out.println("Aluno adicionado com sucesso");
                    curso.adicionarAluno(aluno);
                    break;
                case 2: // exibir informações do curso
                    curso.exibirInformacoescurso();
                    break;

                case 3:
                    curso.exibirStatusAluno();
                    break;
                case 4: // sair
                    System.out.println("Saindo...");
                    continuar = false;
                    break;
                default:
                    System.out.println("Informe uma opção válida");
                    break;
            }
        }

        sc.close();
    }
}

