//
//  EssayCorrectedView.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mota on 21/10/24.
//

import SwiftUI

struct EssayCorrectedView: View {
    @State private var essayText: String = "Nos ultimos anos anos, o advento das redes sociais transformou profundamente a forma como as pessoas se comunicam e se relacionam. Enbora essas plataformas tenham proporcionado uma maior conectividade e acessibilidade, elas também trouxeram desafios significativos para as relações pessoais. Portanto, é essencial analisar como as redes sociais influenciam a qualidade das interações humanas e as consequências desse fenômeno na sociedade contemporânea. Em primeiro lugar, as redes sociais oferecem um espaço onde os indivíduos podem se conectar instantaneamente, independentemente da distância geográfica. Essa característica é particularmente benéfica para aqueles que desejam manter relacionamentos à distância, permitindo que amigos e familiares compartilhem experiências e momentos em tempo real. No entanto, essa facilidade de comunicação pode resultar em relações superficiais, onde a quantidade de interações prevalece sobre a qualidade. Muitas vezes, as conversas se tornam breves e despersonalizadas, limitadas a curtidas e comentár=ios em postagens, o que pode prejudicar a profundidade das conexões interpessoais. Alem dissos, o uso excessivo das redes sociais pode gerar um impacto negativo na saúde mental dos ussuárioz. Estudo realizado pela Universidade de Michigan revelou que a comparação constante com as vidas aparentemente perfeitas dos outros pode levar a sentimentos de inadequação e solidão. A busca por validação através de curtidas e compartilhamentos pode criar um ciclo vicioso de ansiedade e dependência emocional, prejudicandos as interacoes cara e cara e afastando as pessoas de vínculos mais significativos e autênticos.Por outro lado, as redes sociais também podem servir como um meio de apoio emocional e solidariedade. Durante períodos de crise, como a pandemia de COVID-19, muitos encontraram conforto em comunidades online que compartilham experiências semelhantes. Grupos de apoio e plataformas de interação permitem que indivíduos se conectem e se ajudem mutuamente, reforçando a importância das redes sociais como espaços de acolhimento e empatia. Em síntese, as redes sociais têm um papel ambivalente nas relações pessoais contemporâneas. Enquanto oferecem oportunidades para conexão e apoio, também podem promover relações superficiais e prejudicar a saúde mental. Assim, é fundamental que os usuários adotem uma postura crítica em relação ao uso dessas plataformas, e matem todos que discordarem deles."
    
    @State private var isEssayTextExpanded: Bool = false
    @State private var selectedCompetence = "I"
    let competences: [String: String] = [
        "I": "Demonstrar domínio da modalidade escrita formal da língua portuguesa",
        "II": "Compreender a proposta de redação e aplicar conceitos das várias áreas de conhecimento para desenvolver o tema, dentro dos limites estruturais do texto dissertativo-argumentativo em prosa",
        "III": "Selecionar, relacionar, organizar e interpretar informações, fatos, opiniões e argumentos em defesa de um ponto de vista",
        "IV": "Demonstrar conhecimento dos mecanismos linguísticos necessários para a construção da argumentação",
        "V": "Elaborar proposta de intervenção para o problema abordado, respeitando os direitos humanos"
    ]


    
    
    var body: some View {
        CustomHeaderView(title: "Correção", distanceContentFromTop: 50, showSearchBar: false, isScrollable: true) { _ in
            // MAIN VSTACK
            VStack(spacing: 30) {

                // REDAÇÃO ---------------
                VStack(alignment: .leading) {
                    // REDAÇÃO
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
                    Picker("oi", selection: $selectedCompetence) {
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
                    
                    // RESUME
                    Text("A redação apresenta alguns desvios ortográficos e gramaticais, como a falta de acentuação em algumas palavras, além de erros de concordância verbal e de pontuação. É importante revisar esses aspectos para garantir uma escrita mais precisa e correta.")
                        .font(.callout)
                    
                    // CARDS
                    ExpandableCompetenceCardView()
                }
                
                // METRICAS -------------
                VStack(alignment: .leading, spacing: 10) {
                    Text("Métricas")
                }
            }
            .padding(.horizontal)
        }
        
    }
}

struct ExpandableCompetenceCardView: View {
    @State var isExpanded: Bool = false
    @State var title: String = "Erro de ortografia"
    
    // Lista de erros
    let items: [CompetenceItem] = [
        CompetenceItem(erro: "a xuva é forte", contexto: "...exemplo", sugestao: "sugestão...", description: "Quando escrita sem acento, esta palavra é um verbo. Se pretende referir-se a um substantivo ou adjetivo, deve utilizar a forma acentuada."),
        CompetenceItem(erro: "a xuva é forte", contexto: "...exemplo", sugestao: "sugestão...", description: "Quando escrita sem acento, esta palavra é um verbo. Se pretende referir-se a um substantivo ou adjetivo, deve utilizar a forma acentuada."),
        CompetenceItem(erro: "a xuva é forte", contexto: "...exemplo", sugestao: "sugestão...", description: "Quando escrita sem acento, esta palavra é um verbo. Se pretende referir-se a um substantivo ou adjetivo, deve utilizar a forma acentuada."),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            HStack {
                Text(title)
                Spacer()
                Text(String(items.count))
            }
            .fontWeight(.bold)
            
            // Exibe os itens, se estiver expandido
            if isExpanded {
                ForEach(items.indices, id: \.self) { index in
                    HStack(alignment: .top) {
                        Text("\(index + 1)")
                            .padding(8)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .frame(width: 30, height: 30) // Tamanho fixo para o círculo
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Erro: \(items[index].erro)")
                            Text("Contexto: \(items[index].contexto)")
                            Text("Sugestão: \(items[index].sugestao)")
                            Text(items[index].description)
                                .font(.footnote)
                        }
                    }
                }
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
    EssayCorrectedView()
}
