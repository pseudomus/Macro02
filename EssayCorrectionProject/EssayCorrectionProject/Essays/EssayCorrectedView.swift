//
//  EssayCorrectedView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 21/10/24.
//

import SwiftUI


struct EssayCorrectedView: View {
    
    @State private var isEssayTextExpanded: Bool = false
    @State private var selectedCompetence = "I"
    
    let competences: [String: String] = [
        "I": "Demonstrar domínio da modalidade escrita formal da língua portuguesa",
        "II": "Compreender a proposta de redação e aplicar conceitos das várias áreas de conhecimento para desenvolver o tema, dentro dos limites estruturais do texto dissertativo-argumentativo em prosa",
        "III": "Selecionar, relacionar, organizar e interpretar informações, fatos, opiniões e argumentos em defesa de um ponto de vista",
        "IV": "Demonstrar conhecimento dos mecanismos linguísticos necessários para a construção da argumentação",
        "V": "Elaborar proposta de intervenção para o problema abordado, respeitando os direitos humanos"
    ]
    let essayResponse: EssayResponse
    let essayText: String

    
    var body: some View {
        CustomHeaderView(title: "Correção", distanceContentFromTop: 50, showSearchBar: false, isScrollable: true) { _ in
            VStack(spacing: 30) {

                // REDAÇÃO ---------------
                VStack(alignment: .leading) {
                    Text("Redação")
                    
                    VStack(spacing: 10) {
                        Text(essayText)
                            .lineLimit(isEssayTextExpanded ? nil : 3)
                            .animation(nil, value: isEssayTextExpanded)
                        Image(systemName: isEssayTextExpanded ? "chevron.up" : "chevron.down")
                            .foregroundStyle(.black.opacity(0.8))
                    }
                    .padding()
                    .background(Color.gray)
                    .clipShape(.rect(cornerRadius: 12))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isEssayTextExpanded.toggle()
                        }
                    }
                }
                
                // COMPETÊNCIAS ---------------
                VStack(alignment: .leading, spacing: 10) {
                    Text("Competências")
                    Picker("Selecione uma competência", selection: $selectedCompetence) {
                        ForEach(competences.keys.sorted(), id: \.self) { key in
                            Text(key).tag(key)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    if let competenceTitle = competences[selectedCompetence] {
                        Text(competenceTitle)
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    
                    // RESUMO
                    ForEach(essayResponse.competencies, id: \.resume) { competency in
                        VStack(alignment: .leading) {
                            Text(competency.resume)
                                .font(.subheadline)

                            // Utilizando o ExpandableCompetenceCardView
                            ExpandableCompetenceCardView(cards: competency.cards)
                        }
                        .padding(.vertical)
                    }
                    
                    // Exibir métricas
                    Text("Métricas:")
                        .font(.headline)
                    Text("Palavras: \(essayResponse.metrics.words)")
                        .font(.subheadline)
                    Text("Parágrafos: \(essayResponse.metrics.paragraphs)")
                        .font(.subheadline)
                    Text("Linhas: \(essayResponse.metrics.lines)")
                        .font(.subheadline)
                    Text("Conectores: \(essayResponse.metrics.connectors)")
                        .font(.subheadline)
                    Text("Desvios: \(essayResponse.metrics.deviations)")
                        .font(.subheadline)
                    Text("Citações: \(essayResponse.metrics.citations)")
                        .font(.subheadline)
                    Text("Operadores argumentativos: \(essayResponse.metrics.argumentativeOperators)")
                        .font(.subheadline)
                }
            }
            .padding(.horizontal)
        }
    }
}


struct ExpandableCompetenceCardView: View {
    let cards: [Card] // Array de cartões
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Agrupando cartões pelo título
            let groupedCards = Dictionary(grouping: cards) { $0.title ?? "Sem Título" }
            
            ForEach(groupedCards.keys.sorted(), id: \.self) { title in
                let cardsWithTitle = groupedCards[title] ?? []
                let count = cardsWithTitle.count
                
                // Título do card
                HStack {
                    Text(title)
                        .fontWeight(.bold)
                    Spacer()
                    Text(String(count))
                }
                
                // Exibe os itens, se estiver expandido
                if isExpanded {
                    ForEach(cardsWithTitle.indices, id: \.self) { index in
                        let card = cardsWithTitle[index]
                        HStack(alignment: .top) {
                            Text("\(index + 1)")
                                .padding(8)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .frame(width: 30, height: 30) // Tamanho fixo para o círculo
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Elemento: \(card.element ?? "Erro desconhecido")")
                                Text("Contexto: \(card.context ?? "Sem contexto")")
                                Text("Sugestão: \(card.suggestion ?? "Sem sugestão")")
                                Text(card.message ?? "Sem descrição")
                                    .font(.footnote)
                            }
                        }
                    }
                }
                
                Divider() // Adiciona uma linha divisória entre os grupos
            }
        }
        .padding()
        .background(Color.gray.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, lineWidth: 3)
        )
        .onTapGesture {
            withAnimation(.easeInOut) {
                isExpanded.toggle()
                print(isExpanded)
            }
        }
    }
}

// Estrutura de dados para cada item de competência
struct CompetenceItem {
    var erro: String
    var contexto: String
    var sugestao: String
    var description: String
}

#Preview {
    EssayCorrectedView(essayResponse: EssayResponse(theme: "Tema", title: "TITULO", tag: "TAG", competencies: [Competency(resume: "ResumoResumoResumoResumoResumoResumoResumoResumo", cards: [Card(title: "Titulo do card", element: "Elemento", context: "contexto", suggestion: "Sugestao, aoaoaoao", message: "Mesagem")])], metrics: Metrics(words: 10, paragraphs: 10, lines: 10, connectors: 10, deviations: 10, citations: 10, argumentativeOperators: 10)))
}


struct EssayInputView: View {
    @StateObject var essayViewModel = EssayViewModel()
    @State private var theme: String = "A Importância da Educação no Combate à Desigualdade Social"
    @State private var title: String = "Educação e Desigualdade Social"
    @State private var essay: String = "A desigualdade social é um problema muito antigo e presente em várias sociedades ao redor do mundo. No Brasil, esse problema é bastante evidente, especialmente em áreas mais carentes. A educação tem um papel crucial para combater essa desigualdade, porque ao oferecer oportunidade de estudo, todas as pessoas pode ter um futuro melhor e com mais oportunidades de emprego. Entretanto, apesar dos avanços no acesso à educação nos últimos anos, ainda existem muitas desigualdades no sistema educacional. Escolas públicas de áreas periféricas, por exemplo, geralmente não têm a mesma qualidade de ensino que escolas particulares ou públicas de áreas mais ricas. Isso acaba prejudicando os alunos de famílias mais pobres, que não conseguem alcançar os mesmos resultados dos alunos de escolas particulares. Outro ponto a se considerar é a falta de investimento adequado nas escolas públicas. Muitos professores não recebem o apoio necessário para desenvolverem seus trabalhos com eficiência. A falta de material escolar e infraestrutura também é um problema que afeta o aprendizado dos alunos, dificultando ainda mais seu progresso. Portanto, é fundamental que o governo invista mais na educação pública para garantir que todos os estudantes tenham acesso a uma educação de qualidade. Por fim, para que a educação realmente seja um meio eficaz de combate à desigualdade social, é necessário que além do acesso à escola, haja também a implementação de políticas públicas que promovam a permanência e o sucesso dos estudantes no ambiente escolar. Sem essas políticas, muitos jovens acabam abandonando a escola antes mesmo de concluir o ensino básico, o que perpetua o ciclo de pobreza e desigualdade. Conclusão: A educação é, sem dúvida, uma das ferramentas mais importantes para reduzir as desigualdades sociais no Brasil. No entanto, ainda há muitos desafios a serem superados, como a falta de investimento nas escolas públicas e a má qualidade do ensino em algumas regiões do país. Somente através de uma educação acessível e de qualidade para todos será possível construir uma sociedade mais justa e igualitária."
    

    @Environment(\.navigate) var navigate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Campo para o tema
            TextField("Tema", text: $theme)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .font(.headline)

            // Campo para o título
            TextField("Título", text: $title)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .font(.headline)

            // Campo para a redação
            TextEditor(text: $essay)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .frame(minHeight: 200) // Define uma altura mínima para o TextEditor
                .font(.body)

            // Botão para salvar ou enviar a redação
            Button(action: {
                essayViewModel.sendEssayToCorrection(text: essay, title: title, theme: theme)
            }) {
                Text(essayViewModel.isLoading ? "..." : "Confirmar")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .navigationTitle("Criar Redação")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: essayViewModel.isLoading) { oldValue, newValue in
            // Navegar para a próxima view quando a resposta não for mais nil
            if oldValue == true && newValue == false {
                if let essayResponse = essayViewModel.essayResponse {
                    navigate(.essays(.esssayCorrected(essayResponse: essayResponse, text: essay)))
                }
            }
        }
    }
}


import SwiftUI

struct EssayResponseView: View {
    let essayResponse: EssayResponse
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Tema: \(essayResponse.theme)")
                    .font(.headline)
                Text("Título: \(essayResponse.title)")
                    .font(.headline)
                Text("Tag: \(essayResponse.tag.capitalized)") // Exibir a tag
                    .font(.subheadline)

                Text("Competências:")
                    .font(.headline)

                ForEach(essayResponse.competencies, id: \.resume) { competency in
                    VStack(alignment: .leading) {
                        Text(competency.resume)
                            .font(.subheadline)

                        ForEach(competency.cards, id: \.title) { card in
                            VStack(alignment: .leading) {
                                Text("Card: \(card.title ?? "")")
                                    .font(.footnote)
                                Text("Elemento: \(card.element ?? "")")
                                    .font(.footnote)
                                Text("Contexto: \(card.context ?? "")")
                                    .font(.footnote)
                                Text("Sugestão: \(card.suggestion ?? "N/A")")
                                    .font(.footnote)
                                Text("Mensagem: \(card.message ?? "")")
                                    .font(.footnote)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding(.vertical)
                }

                // Exibir métricas
                Text("Métricas:")
                    .font(.headline)
                Text("Palavras: \(essayResponse.metrics.words)")
                    .font(.subheadline)
                Text("Parágrafos: \(essayResponse.metrics.paragraphs)")
                    .font(.subheadline)
                Text("Linhas: \(essayResponse.metrics.lines)")
                    .font(.subheadline)
                Text("Conectores: \(essayResponse.metrics.connectors)")
                    .font(.subheadline)
                Text("Desvios: \(essayResponse.metrics.deviations)")
                    .font(.subheadline)
                Text("Citações: \(essayResponse.metrics.citations)")
                    .font(.subheadline)
                Text("Operadores argumentativos: \(essayResponse.metrics.argumentativeOperators)")
                    .font(.subheadline)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Resposta da Redação")
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    EssayInputView()
}
