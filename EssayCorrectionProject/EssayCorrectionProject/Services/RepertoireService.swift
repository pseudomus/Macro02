//
//  RepertoireService.swift
//  EssayCorrectionProject
//
//  Created by Leonardo Mesquita Alves on 21/10/24.
//

import Foundation

struct Citation {
    let category: RepertoireFilter
    let author: String
    let description: String
    let id = UUID()
}


class MockRepertoireService {
    static func fetchRepertoires() -> [Citation] {
        let mockCitations: [Citation] = [
            // Direitos e Cidadania
            Citation(category: .rights, author: "Euclides da Cunha", description: "Estamos condenados à civilização. Ou progredimos ou desaparecemos."),
            Citation(category: .rights, author: "Millôr Fernandes", description: "Cidadão, num país em que não há nem sombra de cidadania, significa apenas cidade grande."),
            Citation(category: .rights, author: "Hannah Arendt", description: "A essência dos Direitos Humanos é o direito a ter direitos."),
            Citation(category: .rights, author: "Tancredo Neves", description: "A cidadania não é atitude passiva, mas ação permanente, em favor da comunidade."),
            Citation(category: .rights, author: "Constituição Brasileira de 1988", description: "A República Federativa do Brasil, formada pela união indissolúvel dos Estados e Municípios e do Distrito Federal, constitui-se em Estado Democrático de Direito e tem como fundamentos: a soberania, a cidadania, a dignidade da pessoa humana, os valores sociais do trabalho e da livre iniciativa, o pluralismo político."),

            // Tecnologia
            Citation(category: .tecnology, author: "Steve Jobs", description: "A tecnologia move o mundo."),
            Citation(category: .tecnology, author: "Albert Einstein", description: "O espírito humano precisa prevalecer sobre a tecnologia."),
            Citation(category: .tecnology, author: "Pablo Picasso", description: "Computadores são inúteis. Eles só podem dar respostas."),
            Citation(category: .tecnology, author: "Albert Einstein", description: "Se tornou aparentemente óbvio que nossa tecnologia excedeu nossa humanidade."),
            Citation(category: .tecnology, author: "Bill Gates", description: "A tecnologia é só uma ferramenta. No que se refere a motivar as crianças e conseguir que trabalhem juntas, um professor é um recurso mais importante."),

            // Economia
            Citation(category: .economy, author: "Henry Ford", description: "Economia, frequentemente, não tem relação com o total de dinheiro gasto, mas com a sabedoria empregada ao gastá-lo."),
            Citation(category: .economy, author: "Marquês de Maricá", description: "A economia do tempo é menos vulgar e mais importante que a do dinheiro."),
            Citation(category: .economy, author: "Adam Smith", description: "A riqueza de uma nação se mede pela riqueza do povo e não pela riqueza dos príncipes."),
            Citation(category: .economy, author: "Herbert José de Sousa (Betinho)", description: "Um país não muda pela sua economia, sua política e nem mesmo sua ciência; muda sim pela sua cultura."),

            // Educação
            Citation(category: .education, author: "Paulo Freire", description: "Se a educação sozinha não transforma a sociedade, sem ela tampouco a sociedade muda."),
            Citation(category: .education, author: "William Arthur Lewis", description: "Educação nunca foi despesa. Sempre foi investimento com retorno garantido."),
            Citation(category: .education, author: "Augusto Cury", description: "Frágeis usam a violência, e os fortes, as ideias."),
            Citation(category: .education, author: "Sócrates", description: "Só sei que nada sei."),
            Citation(category: .education, author: "Nelson Mandela", description: "A educação é a arma mais poderosa que você pode usar para mudar o mundo."),
            Citation(category: .education, author: "Aristóteles", description: "A educação tem raízes amargas, mas os seus frutos são doces."),
            Citation(category: .education, author: "Pitágoras", description: "Educai as crianças e não será preciso punir os homens."),

            // Arte e Cultura
            Citation(category: .culture, author: "Selma Lagerlöf", description: "Cultura é o que resta quando esquecemos tudo o que aprendemos."),
            Citation(category: .culture, author: "Aristóteles", description: "A cultura é o melhor conforto para a velhice."),
            Citation(category: .culture, author: "Ferreira Gullar", description: "A arte existe porque a vida não basta."),
            Citation(category: .culture, author: "António Lobo Antunes", description: "A cultura assusta muito. É uma coisa apavorante para os ditadores. Um povo que lê nunca será um povo de escravos."),
            Citation(category: .culture, author: "Visconde de Bonald", description: "A cultura forma sábios; a educação, homens."),

            // Meio Ambiente
            Citation(category: .nature, author: "Barack Obama", description: "Nós somos a primeira geração a sentir os impactos da mudança climática e a última geração que pode fazer algo sobre isso."),
            Citation(category: .nature, author: "Arthur Schopenhauer", description: "O homem fez da Terra um inferno para os animais."),
            Citation(category: .nature, author: "Constituição Federal de 1988", description: "Todos têm direito ao meio ambiente ecologicamente equilibrado, bem de uso comum do povo e essencial à sadia qualidade de vida."),
            Citation(category: .nature, author: "Martin Luther King", description: "Se soubesse que o mundo se acaba amanhã, eu ainda hoje plantaria uma árvore."),

            // Saúde e Ciência
            Citation(category: .health, author: "OMS", description: "Saúde é o estado de completo bem-estar físico, mental e social e não somente a ausência de doença."),
            Citation(category: .health, author: "Constituição Federal do Brasil", description: "A saúde é direito de todos e dever do estado, garantido mediante políticas sociais e econômicas."),
            Citation(category: .health, author: "Hipócrates", description: "O homem saudável é aquele que possui um estado mental e físico em perfeito equilíbrio."),
            Citation(category: .health, author: "Franco Basaglia", description: "A saúde mental é um direito, não um privilégio."),

            // Política
            Citation(category: .politics, author: "Platão", description: "O castigo dos bons que não fazem política é serem governados pelos maus."),
            Citation(category: .politics, author: "Max Frisch", description: "Quem não se ocupa de política já tomou a decisão política de que gostaria de se ter poupado: serve o partido dominante."),
            Citation(category: .politics, author: "Angela Davis", description: "A política não se situa no polo oposto ao de nossa vida. Desejemos ou não, ela permeia nossa existência, insinuando-se nos espaços mais íntimos."),
            Citation(category: .politics, author: "Leandro Karnal", description: "Democracia não é o paraíso, mas ela consegue garantir que a gente não chegue no inferno."),
            Citation(category: .politics, author: "Malala Yousafzai", description: "Educação não melhora apenas a vida individual dessas meninas, mas também o país todo – a democracia, economia, estabilidade.")
        ]
        
        return mockCitations
    }
}

class RepertoireService: NetworkService {
    func fetchRepertoires(completion: @escaping (Result<[Article], NetworkError>) -> Void) {
        guard let url = URL(string: Endpoints.articles) else {
            completion(.failure(.invalidURL))
            return
        }
        
        request(url: url, completion: completion)
    }
}

struct Repertoire: Codable {
    let article_id: String
    let title: String
    let source_name: String
    let source_icon: String?
    let pubDate: String
    let category: [String]
    let image_url: String?
    let link: String
}
