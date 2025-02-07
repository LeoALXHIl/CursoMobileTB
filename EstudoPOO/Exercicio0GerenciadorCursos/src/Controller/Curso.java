package Controller;

import Model.Professor;
import Model.Aluno;

import java.util.ArrayList;
import java.util.List;

public class Curso {
    // atributos - privados
    private String nomecurso;
    private Professor professor;
    private List<Aluno> alunos;

    // metodos - publicos
    // construtor
    public Curso(String nomecurso, Professor professor) {
        this.nomecurso = nomecurso;
        this.professor = professor;
        this.alunos = new ArrayList<>();
    }

    // adicionar alunos
    public void adicionarAluno(Aluno aluno) {
        alunos.add(aluno);
    }

    // exibir informações
    public void exibirInformacoes() {
        System.out.println("Nome do Curso: " + nomecurso);
        System.out.println("Professor: " + professor.getNome());
        // loop - foreach
        int i = 1;
        for (Aluno aluno : alunos) {
            System.out.println(i + ". " + aluno.getNome());
            aluno.exibirInformacoes();
            aluno.avaliarDesempenho();
            i++;
        }
    }

    // exibir status do curso
    public void exibirStatusAluno() {
        int i = 1;
       for (Aluno aluno : alunos) {
            if (aluno.getNota() >= 6) {
                System.out.println(i + ". " + aluno.getNome() + " Aprovado");
            } else {
                System.out.println(i + ". " + aluno.getNome() + " Reprovado");
            }
            i++;
        }
    }
    

    public void exibirInformacoescurso() {
        exibirInformacoes();
    }
}
