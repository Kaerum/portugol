programa
{
	inclua biblioteca Graficos --> g
	inclua biblioteca Teclado --> kb
	inclua biblioteca Matematica --> mat
	inclua biblioteca Tipos --> tipos
	inclua biblioteca Util --> util
	inclua biblioteca Mouse --> mouse
	inclua biblioteca Objetos --> obj


	// Tipos de relatos
	const inteiro RELATO_ERRO = 0
	const inteiro RELATO_AVISO = 1
	const inteiro RELATO_NORMAL = 2
	
	funcao relatar(inteiro tipo, cadeia relato) {
		// a ser definido no futuro quando tivermos mais base
	}
	
	const inteiro MAXIMO_DE_ELEMENTOS = 5000
	
	// Janela
	const inteiro JANELA_LARGURA_MAXIMA = 3840
	const inteiro JANELA_ALTURA_MAXIMA = 2160
	inteiro janela_largura = 1200
	inteiro janela_altura = 600
	inteiro janela_distribuicao[JANELA_LARGURA_MAXIMA][JANELA_ALTURA_MAXIMA]

	// Admistração de objetos
	const inteiro MAXIMO_DE_PAIS = 3000
	const inteiro MAXIMO_DE_FILHOS = 200

	inteiro quantidade_objetos = 0
	inteiro quantidade_imagens = 0
	inteiro quantidade_filhos[MAXIMO_DE_PAIS]
	
	inteiro objetos[MAXIMO_DE_ELEMENTOS]
	inteiro filhos[MAXIMO_DE_PAIS][MAXIMO_DE_FILHOS]
	//inteiro pais[MAXIMO_DE_PAIS]
	inteiro clickaveis[MAXIMO_DE_ELEMENTOS]
	inteiro moviveis[MAXIMO_DE_ELEMENTOS]
	inteiro objetos_processados[MAXIMO_DE_ELEMENTOS]
	inteiro imagens[MAXIMO_DE_ELEMENTOS]

	// Tipos de componentes da interface
	const inteiro TIPOS_RETANGULO = 0
	const inteiro TIPOS_CAIXA_TEXTO = 1
	const inteiro TIPOS_BOTAO = 2

	// Tipos de colisões possíveis
	const inteiro COLISAO_DENTRO = 0
	const inteiro COLISAO_FORA = 1
	const inteiro COLISAO_DENTRO_FORA = 2
	const inteiro COLISAO_FORA_DENTRO = 3
	const inteiro COLISAO_IMPOSSIVEL = 4

	// Entrada de mouse
	logico mouseE_pressionado = falso
	logico mouseM_pressionado = falso
	logico mouseD_pressionado = falso
	logico mouseE_carregando = falso
	logico mouseM_carregando = falso
	logico mouseD_carregando = falso
	inteiro mouseX = 0
	inteiro mouseY = 0

	// Padrões de estilização
	const logico PADROES_ARREDONDADO = falso
	const logico PADROES_PREENCHER = falso
	const inteiro PADROES_OPACIDADE = 255
	const inteiro PADROES_ROTACAO = 0
	const inteiro PADROES_COR = -1
	// Caixas de texto
	const logico PADROES_ITALICO = falso
	const logico PADROES_NEGRITO = falso
	const logico PADROES_SUBLINHADO = falso
	const cadeia PADROES_FONTE = "Arial"
	const real PADROES_TAMANHO_FONTE = 16.0

	// Valores atuais de estilização
	logico ATUAL_ARREDONDADO = PADROES_ARREDONDADO
	logico ATUAL_PREENCHER = PADROES_PREENCHER
	inteiro ATUAL_OPACIDADE = PADROES_OPACIDADE
	inteiro ATUAL_ROTACAO = PADROES_ROTACAO
	inteiro ATUAL_COR = PADROES_COR
	// Caixas de texto
	logico ATUAL_ITALICO = PADROES_ITALICO
	logico ATUAL_NEGRITO = PADROES_NEGRITO
	logico ATUAL_SUBLINHADO = PADROES_SUBLINHADO
	cadeia ATUAL_FONTE = PADROES_FONTE
	real ATUAL_TAMANHO_FONTE = PADROES_TAMANHO_FONTE


	// Variáveis de gráfico
	inteiro opacidade = PADROES_OPACIDADE
	funcao mudar_opacidade(inteiro o) {
		opacidade = o
		g.definir_opacidade(opacidade)
	}
	inteiro rotacao = PADROES_ROTACAO
	funcao mudar_rotacao(inteiro r) {
		rotacao = r
		g.definir_rotacao(rotacao)
	}
	inteiro cor = PADROES_COR
	funcao mudar_cor(inteiro c) {
		cor = c
		g.definir_cor(cor)
	}
	logico italico = PADROES_ITALICO
	funcao mudar_italico(logico i) {
		italico = i
		g.definir_estilo_texto(italico, negrito, sublinhado)
	}
	logico negrito = PADROES_NEGRITO
	funcao mudar_negrito(logico n) {
		negrito = n
		g.definir_estilo_texto(italico, negrito, sublinhado)
	}
	logico sublinhado = PADROES_SUBLINHADO
	funcao mudar_sublinhado(logico s) {
		sublinhado = s
		g.definir_estilo_texto(italico, negrito, sublinhado)
	}
	cadeia fonte = PADROES_FONTE
	funcao mudar_fonte(cadeia f) {
		fonte = f
		g.definir_fonte_texto(f)
	}
	real tamanho_fonte = PADROES_TAMANHO_FONTE
	funcao mudar_tamanho_fonte(real t) {
		tamanho_fonte = t
		g.definir_tamanho_texto(tamanho_fonte)
	}
	
	

	funcao inteiro receber_pai(inteiro objeto) {
		retorne obj.obter_propriedade_tipo_inteiro(objeto, "pai")
	}

	funcao vazio inserir_pai(inteiro filho, inteiro pai) {
		obj.atribuir_propriedade(filho, "pai", pai)
	}

	// O ideal é checar se nenhum filho é o pai do futuro pai, se der problema no futuro, pode ser isso aqui
	funcao logico adotar(inteiro pai, inteiro filho) {
		se (pai >= MAXIMO_DE_PAIS) {
			relatar(RELATO_ERRO, "Chegamos no limite de pais.")
			retorne falso 
		}
		se (quantidade_filhos[pai] > MAXIMO_DE_FILHOS) {
			relatar(RELATO_ERRO, "O objeto " + pai + " chegou no limite de filhos.")
			retorne falso
		}
		inteiro avo = receber_pai(pai)
		se (avo == filho) {
			retorne falso
		} senao {
			filhos[pai][quantidade_filhos[pai]] = filho
			inserir_pai(filho, pai)
			quantidade_filhos[pai] += 1
		}
		retorne verdadeiro
	}

	funcao logico colisao_quadrado_ponto(inteiro x, inteiro y, inteiro h, inteiro w, inteiro x2, inteiro y2) {
		retorne x2 > x e x2 < x + w e y2 > y e y2 < y + h
	}

	funcao inteiro colisao_quadrado_quadrado(inteiro x, inteiro y, inteiro h, inteiro w, inteiro x2, inteiro y2, inteiro h2, inteiro w2) {
		logico ponto_esquerdo_superior_dentro = colisao_quadrado_ponto(x, y, h, w, x2, y2)
		logico ponto_direito_inferior_dentro = colisao_quadrado_ponto(x, y, h, w, x2 + w2, y2 + h2)
		se (ponto_esquerdo_superior_dentro e ponto_direito_inferior_dentro) {
			retorne COLISAO_DENTRO
		} senao se (ponto_esquerdo_superior_dentro e nao ponto_direito_inferior_dentro) {
			retorne COLISAO_DENTRO_FORA
		} senao se (nao ponto_esquerdo_superior_dentro e ponto_direito_inferior_dentro) {
			retorne COLISAO_FORA_DENTRO
		} senao se (nao ponto_esquerdo_superior_dentro e nao ponto_direito_inferior_dentro) {
			retorne COLISAO_FORA
		}
		retorne COLISAO_IMPOSSIVEL
	}


	funcao logico checar_objeto_fraco(inteiro objeto) {
		se (objeto <= 0 ou objeto >= MAXIMO_DE_ELEMENTOS) {
			retorne falso
		}
		retorne verdadeiro
	}
	
	funcao mudar_objeto_tipo(inteiro objeto, inteiro tipo) {
		se (checar_objeto_fraco(objeto)) {
			obj.atribuir_propriedade(objeto, "tipo", tipo)
		}
	}

	// Para poder fazer queries
	funcao inteiro criar_objeto_base_nomeado(inteiro tipo, cadeia nome) {
		inteiro objeto = criar_objeto_base(tipo)
		obj.atribuir_propriedade(objeto, "nome", nome)
		retorne objeto
	}

	funcao inteiro criar_objeto_base(inteiro tipo) {
		inteiro objeto = obj.criar_objeto()
		se (nao checar_objeto_fraco(objeto)) {
			relatar(RELATO_ERRO, "Chegamos no limite de objetos, redirecionando para o objeto 0")
			retorne 0
		}
		obj.atribuir_propriedade(objeto, "x", 0)
		obj.atribuir_propriedade(objeto, "y", 0)
		obj.atribuir_propriedade(objeto, "w", 0)
		obj.atribuir_propriedade(objeto, "h", 0)
		obj.atribuir_propriedade(objeto, "cameraX", 0)
		obj.atribuir_propriedade(objeto, "cameraY", 0)
		obj.atribuir_propriedade(objeto, "visivel", falso)
		obj.atribuir_propriedade(objeto, "foco", falso)
		obj.atribuir_propriedade(objeto, "tipo", tipo)
		obj.atribuir_propriedade(objeto, "pai", 0)
		obj.atribuir_propriedade(objeto, "opacidade", ATUAL_OPACIDADE)
		obj.atribuir_propriedade(objeto, "rotacao", ATUAL_ROTACAO)
		obj.atribuir_propriedade(objeto, "cor", ATUAL_COR)
		retorne objeto
	}

	funcao inteiro criar_retangulo() {
		inteiro retangulo = criar_objeto_base(TIPOS_RETANGULO)
		obj.atribuir_propriedade(retangulo, "arredondado", ATUAL_ARREDONDADO)
		obj.atribuir_propriedade(retangulo, "preencher", ATUAL_PREENCHER)
		retorne retangulo
	}

	funcao inteiro criar_caixa_texto(cadeia texto) {
		inteiro objeto = criar_objeto_base(TIPOS_CAIXA_TEXTO)
		obj.atribuir_propriedade(objeto, "text", texto)
		obj.atribuir_propriedade(objeto, "italico", ATUAL_ITALICO)
		obj.atribuir_propriedade(objeto, "negrito", ATUAL_NEGRITO)
		obj.atribuir_propriedade(objeto, "sublinhado", ATUAL_SUBLINHADO)
		obj.atribuir_propriedade(objeto, "fonte", ATUAL_FONTE)
		obj.atribuir_propriedade(objeto, "tamanho_fonte", ATUAL_TAMANHO_FONTE)
		real tamanho_font = tamanho_fonte // Temporariamente mudamos o tamanho da fonte para poder calcular o tamanho correto
		g.definir_tamanho_texto(ATUAL_TAMANHO_FONTE)
		obj.atribuir_propriedade(objeto, "h", g.altura_texto(texto))
		obj.atribuir_propriedade(objeto, "w", g.largura_texto(texto))
		g.definir_tamanho_texto(tamanho_font)
		retorne objeto
	}

	funcao inteiro criar_botao(cadeia texto, cadeia func) {
		inteiro botao = criar_retangulo()
		mudar_objeto_tipo(botao, TIPOS_BOTAO)
		inteiro filho_texto = criar_caixa_texto(texto)
		adotar(botao, filho_texto)
		obj.atribuir_propriedade(botao, "id", func)
		retorne botao
	}
	
	

	funcao inteiro nth_filho_tipo(inteiro n, inteiro tipo, inteiro objeto) {
		se (n >= MAXIMO_DE_FILHOS ou objeto >= MAXIMO_DE_PAIS) {
			relatar(RELATO_ERRO, "Houve a tentativa de acessar um filho ou pai inexistente enquanto fazia uma query")
			retorne 0 
		} senao {
			// to be defined
		}
		relatar(RELATO_ERRO, "Aconteceu um erro inesperado enquanto fazia uma query no objeto " + objeto + " procurando o " + n + " filho do tipo " + tipo)
		retorne 0
	}


	funcao renderizar_retangulo(inteiro objeto, inteiro x, inteiro y, inteiro h, inteiro w) {
		
	}

	funcao renderizar_caixa_texto(inteiro objeto, inteiro x, inteiro y, inteiro h, inteiro w) {
		
	}

	
	funcao renderizar_botao(inteiro objeto, inteiro x, inteiro y, inteiro h, inteiro w) {
		
	}

	// Manda o objeto para a função correta renderizar
	funcao renderizar_tipo(inteiro tipo, inteiro objeto, inteiro x, inteiro y, inteiro h, inteiro w) {
		escolha(tipo) {
		caso TIPOS_RETANGULO:
			renderizar_retangulo(objeto, x, y, h, w)
			pare
		caso TIPOS_CAIXA_TEXTO:
			renderizar_caixa_texto(objeto, x, y, h, w)
			pare
		caso TIPOS_BOTAO:
			renderizar_botao(objeto, x, y, h, w)
			pare
		caso contrario:
			relatar(RELATO_ERRO, "Houve a tentativa de renderizar um tipo desconhecido com enum: " + tipo)
			pare
		}
	}
		// Renderiza um objeto num buffer para que esse buffer nos ajude com desenhos parciais, depois renderiza para a tela
	funcao renderizar_objeto(inteiro objeto, inteiro x, inteiro y, inteiro h, inteiro w, inteiro canvas_h, inteiro canvas_w) {
		inteiro tipo = obj.obter_propriedade_tipo_inteiro(objeto, "tipo")
		inteiro opacidade = obj.atribuir_propriedade(objeto, "opacidade", ATUAL_OPACIDADE)
		inteiro rotacao = obj.atribuir_propriedade(objeto, "rotacao", ATUAL_ROTACAO)
		inteiro cor = obj.atribuir_propriedade(objeto, "cor", ATUAL_COR)
		obj.atribuir_propriedade(objeto, "arredondado", ATUAL_ARREDONDADO)
		obj.atribuir_propriedade(objeto, "preencher", ATUAL_PREENCHER)
		renderizar_tipo(tipo, objeto, x, y, h, w)
	}
	
	// Recalcula posição ou tamanho do objeto a depender de sua relação com o objeto pai
	funcao pre_renderizar_objeto(inteiro objeto) { 
		logico visivel = obj.obter_propriedade_tipo_logico(objeto, "visivel")
		inteiro opacidade = obj.obter_propriedade_tipo_inteiro(objeto, "opacidade")
		se (nao visivel ou opacidade <= 0) { // Não renderiza caso o objeto esteja invisível
			retorne
		}
		inteiro x = obj.obter_propriedade_tipo_inteiro(objeto, "x")
		inteiro y = obj.obter_propriedade_tipo_inteiro(objeto, "y")
		inteiro h = obj.obter_propriedade_tipo_inteiro(objeto, "h")
		inteiro w = obj.obter_propriedade_tipo_inteiro(objeto, "w")
		inteiro pai_cx = 0 
		inteiro pai_cy = 0
		inteiro pai_h = janela_altura
		inteiro pai_w = janela_largura
		inteiro canvas_w = w
		inteiro canvas_h = h
		inteiro endereco_pai = receber_pai(objeto)
		se (endereco_pai != 0) { // 0 indica que não existe um objeto
			pai_cx = obj.obter_propriedade_tipo_inteiro(endereco_pai, "cameraX")
			pai_cy = obj.obter_propriedade_tipo_inteiro(endereco_pai, "cameraY")
			pai_h = obj.obter_propriedade_tipo_inteiro(endereco_pai, "h")
			pai_w = obj.obter_propriedade_tipo_inteiro(endereco_pai, "w")
		}
		inteiro relacao_posicao = colisao_quadrado_quadrado(pai_cx, pai_cy, pai_h, pai_w, x, y, h, w)
		escolha(relacao_posicao) {
		caso COLISAO_DENTRO:
			pare
		caso COLISAO_FORA: //não renderiza pois estamos fora do corpo do pai
			retorne
			pare
		caso COLISAO_DENTRO_FORA: // recalculamos nosso tamanho para ficarmos dentro do pai
			canvas_w = pai_cx + pai_w - x
			canvas_h = pai_cy + pai_h - y
			pare
		caso COLISAO_FORA_DENTRO: // Por enquanto não lidamos com essa situação
			canvas_w = w - x + pai_cx
			canvas_h = h - y + pai_cy
			pare
		caso contrario:
			relatar(RELATO_ERRO, "Ocorreu uma colisão impossível!")
			pare
		}
		renderizar_objeto(objeto, x, y, h, w, canvas_h, canvas_w)
	}

	funcao processar_objeto(inteiro objeto) {
		
	}

	funcao renderizar() {
		inteiro objeto = 0
		
	}

	funcao pre_renderizar() {
		para(inteiro i = 0; i < quantidade_imagens; i++) {
			g.liberar_imagem(imagens[i])
		}
	}

	funcao pos_renderizar() {
		para(inteiro i = 0; i < quantidade_objetos; i++) {
			objetos_processados[i] = 0
		}
	}

	funcao inicializar_graficos() {
		g.iniciar_modo_grafico(verdadeiro)
		janela_largura = g.largura_tela()
		janela_altura = g.altura_tela()
		g.definir_dimensoes_janela(janela_largura, janela_altura)
		g.definir_titulo_janela("Algorítmo")
	}

	funcao inicializar_objetos() {
		obj.criar_objeto() // nenhum objeto pode ter ID = 0, então nos livramos dele no ínicio.
	}

	funcao finalizar() {
		g.encerrar_modo_grafico()
	}

	funcao atualizar_mouse() {
		mouseX = mouse.posicao_x()
		mouseY = mouse.posicao_y()
		mouseE_pressionado = mouse.botao_pressionado(mouse.BOTAO_ESQUERDO)
		mouseM_pressionado = mouse.botao_pressionado(mouse.BOTAO_MEIO)
		mouseD_pressionado = mouse.botao_pressionado(mouse.BOTAO_DIREITO)
	}
	
	funcao inicio()
 	{
		inicializar_graficos()
		enquanto (nao kb.tecla_pressionada(kb.TECLA_ESC))
		{
			atualizar_mouse()
		}
		finalizar()
	}

	
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 13476; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz;
 */