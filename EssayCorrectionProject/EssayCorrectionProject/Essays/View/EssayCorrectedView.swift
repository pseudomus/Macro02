//
//  EssayCorrectedView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 21/10/24.
//

import SwiftUI

// MARK: - ESSAY CORRECTED
struct EssayCorrectedView: View {
    @EnvironmentObject var essayViewModel: EssayViewModel
    @Environment(\.navigate) var navigate

    @State private var isEssayTextExpanded: Bool = false
    @State private var selectedCompetenceIndex: Int = 0
    @State private var scrollProxy: ScrollViewProxy? = nil
    @State private var highlightedKeyword: String? = nil

    // Dicionário com números romanos e os títulos das competências
    let competences: [String: String] = [
        "I": "Demonstrar domínio da modalidade escrita formal da língua portuguesa",
        "II": "Compreender a proposta de redação e aplicar conceitos das várias áreas de conhecimento para desenvolver o tema, dentro dos limites estruturais do texto dissertativo-argumentativo em prosa",
        "III": "Selecionar, relacionar, organizar e interpretar informações, fatos, opiniões e argumentos em defesa de um ponto de vista",
        "IV": "Demonstrar conhecimento dos mecanismos linguísticos necessários para a construção da argumentação",
        "V": "Elaborar proposta de intervenção para o problema abordado, respeitando os direitos humanos"
    ]
    @State var essayResponse: EssayResponse? = nil // resposta da correção
    let essayText: String // texto da redação
    @State private var fontSize: CGFloat = 16

    var body: some View {
        CustomHeaderView(showCredits: false, title: "Correção", distanceContentFromTop: 50, showSearchBar: false, isScrollable: true, numOfItems: competences.count) { _ in
            ScrollViewReader { proxy in
                if let essayResponse = essayResponse {
                    VStack(spacing: 30) {
                        // Redação
                        essayExpandableView()
                            .id("REDACAO")
                        
                        // competências e cards
                        competencesWithCardsView(essayResponse: essayResponse)
                            
                        Divider()
                        
                        // métricas
                        metricsView(essayResponse: essayResponse)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                    .onAppear { scrollProxy = proxy }
                } else {
                    ProgressView("Carregando")
                }
            }
        }
        .overlay(alignment: .topLeading){
            Button {
                navigate(.popBackToRoot)
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Redações")
                }.foregroundStyle(.white)
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .onChange(of: essayViewModel.isLoading){ _, newValue in
            if !newValue {
                essayResponse = essayViewModel.essayResponse
            }
        }

    }
    
    @ViewBuilder
    private func essayExpandableView() -> some View {
        VStack(alignment: .leading) {
            Text("Redação")
                .font(.title2)

            VStack(spacing: 10) {
                // Exibe o texto modificado com a palavra-chave sublinhada
                if let attributedText = generateAttributedText(fullText: essayText, keyword: highlightedKeyword) {
                    Text(attributedText)
                        .lineLimit(isEssayTextExpanded ? nil : 3)
                        .animation(nil, value: isEssayTextExpanded)
                } else {
                    // Exibe o texto completo sem modificações
                    Text(essayText)
                        .lineLimit(isEssayTextExpanded ? nil : 3)
                        .animation(nil, value: isEssayTextExpanded)
                }

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
    }
    @ViewBuilder
    private func competencesWithCardsView(essayResponse: EssayResponse) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Competências")
                .font(.title2)

            
            // Picker usando o índice
            Picker("Selecione uma competência", selection: $selectedCompetenceIndex) {
                ForEach(Array(competences.keys).indices, id: \.self) { index in
                    let key = Array(competences.keys.sorted())[index]
                    Text(key).tag(index) // Mostrando o número romano "I", "II", etc.
                }
            }
            .pickerStyle(.segmented)
            
            // Exibe o título da competência com base na seleção do Picker
            let selectedKey = Array(competences.keys.sorted())[selectedCompetenceIndex]
            
            if competences.keys.contains(selectedKey) {
                if let competenceTitle = competences[selectedKey] {
                    Text(competenceTitle)
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            } else {
                Text("Sem título para a competência selecionada.")
                    .font(.footnote)
                    .fontWeight(.semibold)
            }
            
            // RESUMO E CARDS
            let selectedCompetency = essayResponse.competencies[selectedCompetenceIndex]
            VStack(alignment: .leading, spacing: 10) {
                Text(selectedCompetency.resume) // Resumo
                    .font(.body)
                if !selectedCompetency.cards.isEmpty {
                    ExpandableCompetenceCardView(cards: selectedCompetency.cards,
                                                 competenceIndex: selectedCompetenceIndex,
                                                 isEssayTextExpanded: $isEssayTextExpanded,
                                                 scrollProxy: $scrollProxy,
                                                 highlightedKeyword: $highlightedKeyword,
                                                 scrollToKeyword: { keyword in
                        self.scrollToKeyword(keyword)
                    })
                }
            }
        }
    }
    
    @ViewBuilder
    private func metricsView(essayResponse: EssayResponse) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Métricas")
                .font(.title2)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: fontSize > 20 ? 1 : 2), spacing: 10) {
                
                SemiCircularGraphCardComponentView(value: essayResponse.metrics.words, minValue: 0, maxValue: 800, range: (320, 476), title: "Palavras")
                SemiCircularGraphCardComponentView(value: essayResponse.metrics.paragraphs, minValue: 0, maxValue: 10, range: (4, 5), title: "Parágrafos")
                SemiCircularGraphCardComponentView(value: essayResponse.metrics.lines, minValue: 0, maxValue: 30, range: (22, 30), title: "Linhas")
                SemiCircularGraphCardComponentView(value: essayResponse.metrics.connectors, minValue: 0, maxValue: 30, range: (7, 17), title: "Conectivos")
                SemiCircularGraphCardComponentView(value: essayResponse.metrics.deviations, minValue: 0, maxValue: 10, range: (0, 7), title: "Desvios")
                SemiCircularGraphCardComponentView(value: essayResponse.metrics.citations, minValue: 0, maxValue: 10, range: (3, 11), title: "Citações")
                SemiCircularGraphCardComponentView(value: essayResponse.metrics.argumentativeOperators, minValue: 0, maxValue: 30, range: (10, 17), title: "Operadores argumentativos")
                            
            }
        }
    }
    
    // MARK: - FUNCTIONS
    // Função que gera o AttributedString com sublinhado na palavra-chave
    private func generateAttributedText(fullText: String, keyword: String?) -> AttributedString? {
        guard let keyword = keyword, !keyword.isEmpty else {
            return nil
        }
        
        var attributedText = AttributedString(fullText)
        
        if let range = attributedText.range(of: keyword) {
            attributedText[range].underlineStyle = .single
        }
        
        return attributedText
    }

    
    // Função para rolar até a palavra-chave
    private func scrollToKeyword(_ keyword: String) {
        highlightedKeyword = keyword
        for (index, paragraph) in essayText.split(separator: "\n").enumerated() {
            if paragraph.contains(keyword) {
                scrollProxy?.scrollTo("paragraph\(index)", anchor: .bottom) // Rolando para o parágrafo que contém a palavra-chave
                break
            }
        }
    }
}

// MARK: - CARD
struct ExpandableCompetenceCardView: View {
    let cards: [Card]
    let groupedCards: [String: [Card]]
    let scrollToKeyword: (String) -> Void
    let competenceIndex: Int
    
    @Binding var isEssayTextExpanded: Bool
    @Binding var scrollProxy: ScrollViewProxy?
    @Binding var highlightedKeyword: String?
    
    @State private var expandedStates: [String: Bool] = [:]
    
    init(cards: [Card], competenceIndex: Int, isEssayTextExpanded: Binding<Bool>, scrollProxy: Binding<ScrollViewProxy?>, highlightedKeyword: Binding<String?>, scrollToKeyword: @escaping (String) -> Void) {
        self.cards = cards
        self._isEssayTextExpanded = isEssayTextExpanded
        self._scrollProxy = scrollProxy
        self._highlightedKeyword = highlightedKeyword
        self.scrollToKeyword = scrollToKeyword
        self.competenceIndex = competenceIndex
        
        // agrupando cards
        groupedCards = Dictionary(grouping: cards) { $0.title ?? "" }
    }
    
    var body: some View {
        let predefinedTitles = ["Agente", "Ação", "Efeito", "Modo", "Detalhamento"]

        let displayedTitles = competenceIndex == 4
        ? Array(Set(predefinedTitles).union(groupedCards.keys))
        : groupedCards.keys.sorted()

        ForEach(displayedTitles.sorted(), id: \.self) { title in
            cardSection(title: title)
        }
    }

    
    // MARK: - VIEWS
    @ViewBuilder
    func cardSection(title: String) -> some View {
        let cardsWithTitle = groupedCards[title] ?? []
        let count = cardsWithTitle.count
        let isExpanded = expandedStates[title] ?? false
        
        VStack(alignment: .leading, spacing: 20) {
            sectionHeader(title: title, count: count)
            
            // CONTEÚDO AO EXPANDIR
            if isExpanded {
                ForEach(cardsWithTitle.indices, id: \.self) { index in
                    cardContent(card: cardsWithTitle[index], index: index) // conteúdo
                }
                
                viewErrorsButton(cardsWithTitle: cardsWithTitle) // botão de ver erros na redação
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white, lineWidth: 3)
        )
        // EXPANDIR AO CLICAR NO CARD
        .onTapGesture {
            withAnimation(.easeInOut) {
                expandedStates[title] = !(expandedStates[title] ?? false)
            }
        }
    }
    
    // MARK: - TÍTULO
    @ViewBuilder
    func sectionHeader(title: String, count: Int) -> some View {
        HStack {
            Text(title)
            Spacer()
            // Verifica se o título foi adicionado manualmente
            if let cards = groupedCards[title], !cards.isEmpty {
                if competenceIndex != 4 {
                    Text(count > 1 ? "\(count) erros" : "\(count) erro")
                } else {
                    Image(systemName: "checkmark.seal.fill")
                }
            } else {
                Image(systemName: "xmark.seal.fill")
            }
        }
        .fontWeight(.bold)
    }


    // MARK: - conteúdos do card
    @ViewBuilder
    func cardContent(card: Card, index: Int) -> some View {
        HStack(alignment: .top) {
            // Círculo com o índice
            Text("\(index + 1)")
                .padding(8)
                .background(Color.blue)
                .clipShape(Circle())
                .foregroundStyle(.white)
                .offset(y: -8)
            
            VStack(alignment: .leading, spacing: 8) {
                if let element = card.element {
                    Text("\(Text("Elemento:").bold()) \(element)")
                }
                
                if let context = card.context {
                    Text("\(Text("Contexto:").bold()) \(context)")
                }
                
                if let suggestion = card.suggestion {
                    Text("\(Text("Sugestão:").bold()) \(suggestion)")
                }
                
                if let message = card.message {
                    Text(message)
                        .font(.footnote)
                }
            }
        }
    }
    
    // MARK: - botão de visualizar erros
    @ViewBuilder
    func viewErrorsButton(cardsWithTitle: [Card]) -> some View {
        Button(action: {
            if !isEssayTextExpanded {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeInOut) {
                        isEssayTextExpanded.toggle()
                    }
                }
            }
            // Scroll com animação suave para a redação
            withAnimation(.easeInOut) {
                scrollProxy?.scrollTo("REDACAO", anchor: .bottom)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                highlightedKeyword = "Conclusão"
                scrollToKeyword("Conclusão")
            }
            
        }) {
            HStack {
                Spacer()
                Image(systemName: "eye")
                Text("Visualizar erros na redação")
                Spacer()
            }
        }
        .buttonStyle(.plain)
        .padding(8)
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .frame(maxWidth: .infinity)
    }
}


#Preview {
    EssayCorrectedView(essayResponse: EssayResponse(id: 1, theme: "Tema", title: "TITULO", tag: "TAG", competencies:
                                                        [Competency(resume: "A redação apresenta alguns desvios ortográficos e gramaticais, como a falta de acentuação em algumas palavras, além de erros de concordância verbal e de pontuação. É importante revisar esses aspectos para garantir uma escrita mais precisa e correta.",
                                                                    cards: [Card(title: "Titulo do card",
                                                                                 element: "Elemento",
                                                                                 context: "...contexto",
                                                                                 suggestion: "Sugestao, aoaoaoao",
                                                                                 message: "Mesagem"),
                                                                            Card(title: "Titulo do card",
                                                                                 element: "Elemento",
                                                                                 context: "contexto",
                                                                                 suggestion: "Sugestao, aoaoaoao",
                                                                                 message: "Mesagem"),
                                                                            Card(title: "Titulo do card diferente",
                                                                                 element: "Elemento",
                                                                                 context: "contexto",
                                                                                 suggestion: "Sugestao, aoaoaoao",
                                                                                 message: "Mesagem")]),
                                                         Competency(resume: "222ResumoResumoResumoResumoResumoResumoResumoResumo",
                                                                    cards: [Card(title: "Agente",
                                                                                 element: "222Elemento",
                                                                                 context: "222contexto",
                                                                                 suggestion: "222Sugestao, aoaoaoao",
                                                                                 message: "222Mesagem")])],
                                                    metrics: Metrics(words: 320,
                                                                     paragraphs: 6,
                                                                     lines: 10,
                                                                     connectors: 10,
                                                                     deviations: 10,
                                                                     citations: 10,
                                                                     argumentativeOperators: 10)),
                       essayText: "A desigualdade social é um problema muito antigo e presente em várias sociedades ao redor do mundo. No Brasil, esse problema é bastante evidente, especialmente em áreas mais carentes. A educação tem um papel crucial para combater essa desigualdade, porque ao oferecer oportunidade de estudo, todas as pessoas pode ter um futuro melhor e com mais oportunidades de emprego. Entretanto, apesar dos avanços no acesso à educação nos últimos anos, ainda existem muitas desigualdades no sistema educacional. Escolas públicas de áreas periféricas, por exemplo, geralmente não têm a mesma qualidade de ensino que escolas particulares ou públicas de áreas mais ricas. Isso acaba prejudicando os alunos de famílias mais pobres, que não conseguem alcançar os mesmos resultados dos alunos de escolas particulares. Outro ponto a se considerar é a falta de investimento adequado nas escolas públicas. Muitos professores não recebem o apoio necessário para desenvolverem seus trabalhos com eficiência. A falta de material escolar e infraestrutura também é um problema que afeta o aprendizado dos alunos, dificultando ainda mais seu progresso. Portanto, é fundamental que o governo invista mais na educação pública para garantir que todos os estudantes tenham acesso a uma educação de qualidade. Por fim, para que a educação realmente seja um meio eficaz de combate à desigualdade social, é necessário que além do acesso à escola, haja também a implementação de políticas públicas que promovam a permanência e o sucesso dos estudantes no ambiente escolar. Sem essas políticas, muitos jovens acabam abandonando a escola antes mesmo de concluir o ensino básico, o que perpetua o ciclo de pobreza e desigualdade. Conclusão: A educação é, sem dúvida, uma das ferramentas mais importantes para reduzir as desigualdades sociais no Brasil. No entanto, ainda há muitos desafios a serem superados, como a falta de investimento nas escolas públicas e a má qualidade do ensino em algumas regiões do país. Somente através de uma educação acessível e de qualidade para todos será possível construir uma sociedade mais justa e igualitária.")
    .environmentObject(EssayViewModel())
}






// MARK: - INPUT VIEW
struct EssayInputView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var essayViewModel: EssayViewModel
    
    @State private var theme: String = "A Importância da Educação no Combate à Desigualdade Social"
    @State private var title: String = "Educação e Desigualdade Social"
    @State private var essay: String = "Nos ultimos anos anos, o advento das redes sociais transformou profundamente a forma como as pessoas se comunicam e se relacionam. Embora essas plataformas tenham proporcionado uma maior conectividade e acessibilidade, elas também trouxeram desafios significativos para as relações pessoais. Portanto, é essencial analisar como as redes sociais influenciam a qualidade das interações humanas e as consequências desse fenômeno na sociedade contemporânea. Em primeiro lugar, as redes sociais oferecem um espaço onde os indivíduos podem se conectar instantaneamente, independentemente da distância geográfica. Essa característica é particularmente benéfica para aqueles que desejam manter relacionamentos à distância, permitindo que amigos e familiares compartilhem experiências e momentos em tempo real. No entanto, essa facilidade de comunicação pode resultar em relações superficiais, onde a quantidade de interações prevalece sobre a qualidade. Muitas vezes, as conversas se tornam breves e despersonalizadas, limitadas a curtidas e comentários em postagens, o que pode prejudicar a profundidade das conexões interpessoais. Alem dissos, o uso excessivo das redes sociais pode gerar um impacto negativo na saúde mental dos ussuárioz. Estudo realizado pela Universidade de Michigan revelou que a comparação constante com as vidas aparentemente perfeitas dos outros pode levar a sentimentos de inadequação e solidão. A busca por validação através de curtidas e compartilhamentos pode criar um ciclo vicioso de ansiedade e dependência emocional, prejudicandos as interacoes cara e cara e afastando as pessoas de vínculos mais significativos e autênticos.Por outro lado, as redes sociais também podem servir como um meio de apoio emocional e solidariedade. Durante períodos de crise, como a pandemia de COVID-19, muitos encontraram conforto em comunidades online que compartilham experiências semelhantes. Grupos de apoio e plataformas de interação permitem que indivíduos se conectem e se ajudem mutuamente, reforçando a importância das redes sociais como espaços de acolhimento e empatia. Em síntese, as redes sociais têm um papel ambivalente nas relações pessoais contemporâneas. Enquanto oferecem oportunidades para conexão e apoio, também podem promover relações superficiais e prejudicar a saúde mental. Assim, é fundamental que os usuários adotem uma postura crítica em relação ao uso dessas plataformas, buscando um equilíbrio que valorize tanto as interações virtuais quanto as pessoais. Apenas dessa formas, será possível aproveitar os benefícios das redes sociais sem comprometer a qualidade das relações humana."

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
                guard let user = userViewModel.user else { return }
                essayViewModel.sendEssayToCorrection(text: essay, title: title, theme: theme, userId: user.id)
            }) {
                Text(essayViewModel.isLoading ? "..." : "Confirmar")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundStyle(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .navigationTitle("Criar Redação")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: essayViewModel.isLoading) { _, newValue in
            navigate(.essays(.esssayCorrected(text: essay)))
        }
    }
}




#Preview {
    EssayInputView()
        .environmentObject(EssayViewModel())
        .environmentObject(UserViewModel())
}
