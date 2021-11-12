programa
{
	inclua biblioteca Graficos --> g
	inclua biblioteca Teclado --> kb
	inclua biblioteca Matematica --> mat
	inclua biblioteca Tipos --> tipos
	inclua biblioteca Util --> util
	inclua biblioteca Mouse --> mouse
	inclua biblioteca Objetos --> obj

	//CORES


	// Tipos de relatos
	const inteiro RELATO_NORMAL = 0
	const inteiro RELATO_ERRO = 1
	const inteiro RELATO_AVISO = 2
	const inteiro RELATO_DEBUG = 3
	const inteiro RELATO_VERBOSE = 4

	inteiro NIVEL_RELATO = 4

	cadeia RELATOS_DISPLAY[] = {"NORMAL", "ERRO", "AVISO", "DEBUG", "VERBOSE"}

	// Utilidades
	funcao relatar(inteiro tipo, cadeia relato) {
		se (NIVEL_RELATO >= tipo) {
			escreva("["+ RELATOS_DISPLAY[tipo] + "] " + relato + "\n")// a ser definido no futuro quando tivermos mais base
		}
	}
	funcao real clamp_real(real valor, real minimo, real maximo) {
		se (valor >= minimo e valor <= maximo) {
			retorne valor
		} senao se (valor <= minimo) {
			retorne minimo
		}
		retorne maximo
	}

	funcao inteiro clamp_inteiro(inteiro valor, inteiro minimo, inteiro maximo) {
		se (valor >= minimo e valor <= maximo) {
			retorne valor
		} senao se (valor <= minimo) {
			retorne minimo
		}
		retorne maximo
	}
	
	const inteiro MAXIMO_DE_ELEMENTOS = 5000
	
	// Janela
	const inteiro JANELA_LARGURA_MAXIMA = 3840
	const inteiro JANELA_ALTURA_MAXIMA = 2160
	inteiro janela_largura = 1200
	inteiro janela_altura = 600
	inteiro janela_distribuicao[JANELA_LARGURA_MAXIMA][JANELA_ALTURA_MAXIMA]

	// Admistração de objetos
	inteiro OBJETO_MESTRE = -1
	const inteiro MAXIMO_DE_PAIS = 3000
	const inteiro MAXIMO_DE_FILHOS = 200

	inteiro quantidade_objetos = 0
	inteiro quantidade_filhos[MAXIMO_DE_PAIS]
	
	inteiro objetos[MAXIMO_DE_ELEMENTOS]
	inteiro filhos[MAXIMO_DE_PAIS][MAXIMO_DE_FILHOS]
	//inteiro pais[MAXIMO_DE_PAIS]
	inteiro clickaveis[MAXIMO_DE_ELEMENTOS]
	inteiro moviveis[MAXIMO_DE_ELEMENTOS]
	inteiro objetos_processados[MAXIMO_DE_ELEMENTOS]

	// Buffer de imagens, elas têm de ser desenhadas no final!
	inteiro quantidade_imagens = 0
	inteiro imagens[MAXIMO_DE_ELEMENTOS]
	//inteiro objetos_imagens[JANELA_LARGURA_MAXIMA * JANELA_ALTURA_MAXIMA]

	// Tipos de componentes da interface
	const inteiro TIPOS_MESTRE = 0
	const inteiro TIPOS_RETANGULO = 1
	const inteiro TIPOS_CAIXA_TEXTO = 2
	const inteiro TIPOS_BOTAO = 3

	const cadeia TIPOS[] = {"MESTRE", "RETANGULO", "CAIXA_TEXTO", "BOTAO"}
	
	const inteiro TIPOS_TAMANHOS[] = {15, 19, 16}

	// Tipos de colisões possíveis
	const inteiro COLISAO_DENTRO = 0
	const inteiro COLISAO_FORA = 1
	const inteiro COLISAO_DENTRO_FORA = 2
	const inteiro COLISAO_FORA_DENTRO = 3
	const inteiro COLISAO_IMPOSSIVEL = 4

	const cadeia COLISOES[] = {"DENTRO", "FORA", "DENTRO_FORA", "FORA_DENTRO", "IMPOSSIVEL"}

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
	const logico PADROES_PREENCHER = verdadeiro
	const inteiro PADROES_OPACIDADE = 255
	const inteiro PADROES_ROTACAO = 0
	const inteiro PADROES_COR = -1
	const inteiro PADROES_POSICIONAMENTO = 1
	const inteiro PADROES_DIMENSIONAMENTO = 0
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
	inteiro ATUAL_POSICIONAMENTO = PADROES_POSICIONAMENTO
	inteiro ATUAL_DIMENSIONAMENTO = PADROES_DIMENSIONAMENTO
	// Caixas de texto
	logico ATUAL_ITALICO = PADROES_ITALICO
	logico ATUAL_NEGRITO = PADROES_NEGRITO
	logico ATUAL_SUBLINHADO = PADROES_SUBLINHADO
	cadeia ATUAL_FONTE = PADROES_FONTE
	real ATUAL_TAMANHO_FONTE = PADROES_TAMANHO_FONTE

	// Variáveis de gráfico salvas para serem restauradas a cada objeto desenhado
	inteiro salvo_opacidade = PADROES_OPACIDADE
	inteiro salvo_rotacao = PADROES_ROTACAO
	inteiro salvo_cor = PADROES_COR
	logico salvo_italico = PADROES_ITALICO
	logico salvo_negrito = PADROES_NEGRITO
	logico salvo_sublinhado = PADROES_SUBLINHADO
	cadeia salvo_fonte = PADROES_FONTE
	real salvo_tamanho_fonte = PADROES_TAMANHO_FONTE

	//Tipos de posicionamento
	const inteiro POSICAO_PX = 0
	const inteiro POSICAO_RPAI = 1
	const inteiro POSICAO_ABSOLUTO = 2

	const cadeia POSICOES[] = {"PIXEL RELATIVA AO PAI", "PORCENTAGEM RELATIVA AO PAI", "ABSOLUTO"}
	//Tipos de dimensionamento
	const inteiro DIMENSIONAMENTO_PX = 0
	const inteiro DIMENSIONAMENTO_RPAI = 1

	const cadeia DIMESIONAMENTOS[] = {"PIXEL", "PORCENTAGEM RELATIVA AO PAI"}
	
	// Variáveis de gráfico
	logico houveramMudancas = falso
	inteiro opacidade = PADROES_OPACIDADE
	funcao definir_opacidade(inteiro o) {
		opacidade = o
		g.definir_opacidade(opacidade)
	}
	inteiro rotacao = PADROES_ROTACAO
	funcao definir_rotacao(inteiro r) {
		rotacao = r
		g.definir_rotacao(rotacao)
	}
	inteiro cor = PADROES_COR
	funcao definir_cor(inteiro c) {
		cor = c
		g.definir_cor(cor)
	}
	logico italico = PADROES_ITALICO
	funcao definir_italico(logico i) {
		italico = i
		g.definir_estilo_texto(italico, negrito, sublinhado)
	}
	logico negrito = PADROES_NEGRITO
	funcao definir_negrito(logico n) {
		negrito = n
		g.definir_estilo_texto(italico, negrito, sublinhado)
	}
	logico sublinhado = PADROES_SUBLINHADO
	funcao definir_sublinhado(logico s) {
		sublinhado = s
		g.definir_estilo_texto(italico, negrito, sublinhado)
	}
	funcao definir_estilo(logico i, logico n, logico s) {
		italico = i
		sublinhado = s
		negrito = n
		g.definir_estilo_texto(italico, negrito, sublinhado)
	}
	cadeia fonte = PADROES_FONTE
	funcao definir_fonte(cadeia f) {
		fonte = f
		g.definir_fonte_texto(f)
	}
	real tamanho_fonte = PADROES_TAMANHO_FONTE
	funcao definir_tamanho_fonte(real t) {
		tamanho_fonte = t
		g.definir_tamanho_texto(tamanho_fonte)
	}

	funcao salvar_configuracoes_graficas() {
		salvo_opacidade = opacidade
		salvo_rotacao = rotacao
		salvo_cor = cor
		salvo_italico = italico
		salvo_negrito = negrito
		salvo_sublinhado = sublinhado
		salvo_fonte = fonte
		salvo_tamanho_fonte = tamanho_fonte
	}

	funcao restaurar_configuracoes_graficas() {
		definir_opacidade(salvo_opacidade)
		definir_rotacao(salvo_rotacao)
		definir_cor(salvo_cor)
		definir_italico(salvo_italico)
		definir_negrito(salvo_negrito)
		definir_sublinhado(salvo_sublinhado)
		definir_fonte(salvo_fonte)
		definir_tamanho_fonte(salvo_tamanho_fonte)
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
		retorne x2 >= x e x2 <= x + w e y2 >= y e y2 <= y + h
	}

	funcao inteiro colisao_quadrado_quadrado(inteiro x, inteiro y, inteiro h, inteiro w, inteiro x2, inteiro y2, inteiro h2, inteiro w2) {
		relatar(RELATO_VERBOSE, "Calculando colisao q² x1: " + x + " y1: " + y + " h1: " + h + " w1: " + w + " x2: " + x2 + " y2: " + y2 + " h2: " + h2 + " w2: " + w2)
		logico ponto_esquerdo_superior_dentro = colisao_quadrado_ponto(x, y, h, w, x2, y2)
		logico ponto_direito_inferior_dentro = colisao_quadrado_ponto(x, y, h, w, x2 + w2, y2 + h2)
		relatar(RELATO_VERBOSE, "Colisão 1 : " + ponto_esquerdo_superior_dentro + " Colisão 2 " + ponto_direito_inferior_dentro)
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
		se (objeto >= MAXIMO_DE_ELEMENTOS) {
			relatar(RELATO_ERRO, "Tentativa de usar objeto inválido " + objeto)
			retorne falso
		}
		retorne verdadeiro
	}

	funcao notificarMudancas() {
		houveramMudancas = verdadeiro
	}

	funcao inserir_objeto(inteiro objeto) {
		adotar(OBJETO_MESTRE, objeto)
		quantidade_objetos += 1
		notificarMudancas()
	}
	
	funcao mudar_objeto_tipo(inteiro objeto, inteiro tipo) {
		se (checar_objeto_fraco(objeto)) {
			obj.atribuir_propriedade(objeto, "tipo", tipo)
		}
	}

	// Para poder fazer queries
	funcao nomear_objeto(inteiro objeto, cadeia nome) {
		se (checar_objeto_fraco(objeto)) {
			obj.atribuir_propriedade(objeto, "nome", nome)
		}
	}

	funcao inteiro criar_objeto_base(inteiro tipo) {
		inteiro objeto = obj.criar_objeto()
		se (nao checar_objeto_fraco(objeto)) {
			relatar(RELATO_ERRO, "Chegamos no limite de objetos, redirecionando para o objeto 0")
			retorne 0
		}
		obj.atribuir_propriedade(objeto, "x", 0.0)
		obj.atribuir_propriedade(objeto, "modox", ATUAL_POSICIONAMENTO)
		obj.atribuir_propriedade(objeto, "y", 0.0)
		obj.atribuir_propriedade(objeto, "modoy", ATUAL_POSICIONAMENTO)
		obj.atribuir_propriedade(objeto, "xabsoluto", 0)
		obj.atribuir_propriedade(objeto, "yabsoluto", 0)
		obj.atribuir_propriedade(objeto, "w", 0.0)
		obj.atribuir_propriedade(objeto, "modow", POSICAO_PX)
		obj.atribuir_propriedade(objeto, "h", 0.0)
		obj.atribuir_propriedade(objeto, "modoh", POSICAO_PX)
		obj.atribuir_propriedade(objeto, "cameraX", 0.0)
		obj.atribuir_propriedade(objeto, "cameraY", 0.0)
		obj.atribuir_propriedade(objeto, "visivel", verdadeiro)
		obj.atribuir_propriedade(objeto, "foco", falso)
		obj.atribuir_propriedade(objeto, "tipo", tipo)
		obj.atribuir_propriedade(objeto, "pai", 0)
		obj.atribuir_propriedade(objeto, "opacidade", ATUAL_OPACIDADE)
		obj.atribuir_propriedade(objeto, "rotacao", ATUAL_ROTACAO)
		obj.atribuir_propriedade(objeto, "cor", ATUAL_COR)
		relatar(RELATO_VERBOSE, "Objeto base criado com id " + objeto + " do tipo " + TIPOS[tipo])
		retorne objeto
	}

	funcao inteiro criar_retangulo(real x, real y, real h, real w) {
		inteiro retangulo = criar_objeto_base(TIPOS_RETANGULO)
		obj.atribuir_propriedade(retangulo, "arredondado", ATUAL_ARREDONDADO)
		obj.atribuir_propriedade(retangulo, "preencher", ATUAL_PREENCHER)
		obj.atribuir_propriedade(retangulo, "x", x)
		obj.atribuir_propriedade(retangulo, "y", y)
		obj.atribuir_propriedade(retangulo, "w", w)
		obj.atribuir_propriedade(retangulo, "h", h)
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
		obj.atribuir_propriedade(objeto, "cor", g.COR_AZUL)
		real tamanho_font = tamanho_fonte // Temporariamente mudamos o tamanho da fonte para poder calcular o tamanho correto
		definir_tamanho_fonte(ATUAL_TAMANHO_FONTE)
		obj.atribuir_propriedade(objeto, "h", tipos.inteiro_para_real(g.altura_texto(texto)))
		obj.atribuir_propriedade(objeto, "w", tipos.inteiro_para_real(g.largura_texto(texto)))
		definir_tamanho_fonte(tamanho_font)
		retorne objeto
	}

	funcao inteiro criar_botao(cadeia texto, cadeia func, real x, real y, real h, real w) {
		inteiro botao = criar_retangulo(x, y, h, w)
		mudar_objeto_tipo(botao, TIPOS_BOTAO)
		inteiro filho_texto = criar_caixa_texto(texto)
		adotar(botao, filho_texto)
		obj.atribuir_propriedade(botao, "id", func)
		retorne botao
	}
	
	funcao inteiro criar_objeto_imagem(inteiro imagem, inteiro x, inteiro y) {
		inteiro endereco = obj.criar_objeto()
		obj.atribuir_propriedade(endereco, "imagem", imagem)
		obj.atribuir_propriedade(endereco, "x", x)
		obj.atribuir_propriedade(endereco, "y", y)
		retorne endereco
	}

	funcao inteiro criar_objeto_mestre() {
		inteiro objeto = criar_retangulo(0, 0, janela_altura, janela_largura)
		mudar_objeto_tipo(objeto, TIPOS_MESTRE)
		OBJETO_MESTRE = objeto
		retorne objeto
	}

	funcao inserir_imagem_buffer(inteiro endereco, inteiro x, inteiro y) {
		inteiro objeto = criar_objeto_imagem(endereco, x, y)
		imagens[quantidade_imagens] = objeto
		quantidade_imagens += 1
	}

	funcao inteiro primero_filho_tipo(inteiro objeto, inteiro tipo) {
		se (checar_objeto_fraco(objeto)) {
			para (inteiro i = 0; i < quantidade_filhos[objeto]; i++) {
				inteiro filho = filhos[objeto][i]
				se (checar_objeto_fraco(filho)) {
					inteiro tip = obj.obter_propriedade_tipo_inteiro(filho, "tipo")
					se (tip == tipo) {
						retorne filho
					}
				}
			}
		}
		retorne -1
	}


	funcao renderizar_retangulo(inteiro objeto, real x, real y, real h, real w) {
		logico preencher = obj.obter_propriedade_tipo_logico(objeto, "preencher")
		logico arredondado = obj.obter_propriedade_tipo_logico(objeto, "arredondado")
		g.desenhar_retangulo(x, y, w, h, arredondado, preencher)
		relatar(RELATO_VERBOSE, "Desenhando retângulo " + objeto_para_string(objeto) + "\npreencher " + preencher)
	}

	funcao renderizar_caixa_texto(inteiro objeto, real x, real y, real h, real w) {
		cadeia text = obj.obter_propriedade_tipo_cadeia(objeto, "text")
		logico italic = obj.obter_propriedade_tipo_logico(objeto, "italico")
		logico negrit = obj.obter_propriedade_tipo_logico(objeto, "negrito")
		logico sublinhad = obj.obter_propriedade_tipo_logico(objeto, "sublinhado")
		cadeia font = obj.obter_propriedade_tipo_cadeia(objeto, "fonte")
		real tamanho_font = obj.obter_propriedade_tipo_real(objeto, "tamanho_fonte")
		definir_estilo(italico, negrit, sublinhad)
		definir_fonte(font)
		definir_tamanho_fonte(tamanho_font)
		g.desenhar_texto(x, y, text)
	}

	
	funcao renderizar_botao(inteiro objeto, real x, real y, real h, real w) {
		renderizar_retangulo(objeto, x, y, h, w)
	}

	// Manda o objeto para a função correta renderizar
	funcao renderizar_tipo(inteiro tipo, inteiro objeto, real x, real y, real h, real w) {
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
		caso TIPOS_MESTRE:
			renderizar_retangulo(objeto, x, y, h, w)
			pare
		caso contrario:
			relatar(RELATO_ERRO, "Houve a tentativa de renderizar um tipo desconhecido com enum: " + tipo)
			pare
		}
	}
	
	// Renderiza um objeto num buffer para que esse buffer nos ajude com desenhos parciais, depois renderiza para a tela
	funcao renderizar_objeto(inteiro objeto, inteiro xabsoluto, inteiro yabsoluto, real cx, real cy, real h, real w, inteiro canvas_h, inteiro canvas_w) {
		se (canvas_h <= 0 ou canvas_w <= 0) {
			relatar(RELATO_ERRO, "Canvas de desenho para o objeto " + objeto + " com dimensões inválidas.")
			retorne
		}
		relatar(RELATO_VERBOSE, "Tentando renderizar objeto " + objeto + " num canvas de largura " + canvas_w + " e altura " + canvas_h)
		inteiro tipo = obj.obter_propriedade_tipo_inteiro(objeto, "tipo")
		inteiro rotaca = obj.obter_propriedade_tipo_inteiro(objeto, "rotacao")
		inteiro co = obj.obter_propriedade_tipo_inteiro(objeto, "cor")
		definir_rotacao(rotaca)
		definir_cor(co)
		renderizar_tipo(tipo, objeto, -cx, -cy, h, w) // x e y têm de levar em consideração o x e y da camera
		inserir_imagem_buffer(g.renderizar_imagem(canvas_w, canvas_h), xabsoluto, yabsoluto)
	}

	funcao renderizar_filhos(inteiro objeto) {
		relatar(RELATO_VERBOSE, "Tentando renderizar os filhos do objeto " + objeto)
		para (inteiro i = 0; i < quantidade_filhos[objeto]; i++) {
			inteiro filho = filhos[objeto][i]
			se (checar_objeto_fraco(filho)) {
				pre_renderizar_objeto(filho)
			}
		}
	}

	funcao cadeia objeto_para_string(inteiro objeto) {
		cadeia string = "{\n"
		inteiro tipo = obj.obter_propriedade_tipo_inteiro(objeto, "tipo")
		real x = obj.obter_propriedade_tipo_real(objeto, "x")
		real y = obj.obter_propriedade_tipo_real(objeto, "y")
		real h = obj.obter_propriedade_tipo_real(objeto, "h")
		real w = obj.obter_propriedade_tipo_real(objeto, "w")		
		logico visivel = obj.obter_propriedade_tipo_logico(objeto, "visivel")
		inteiro opacidad = obj.obter_propriedade_tipo_inteiro(objeto, "opacidade")
		inteiro rotaca = obj.obter_propriedade_tipo_inteiro(objeto, "rotacao")
		inteiro co = obj.obter_propriedade_tipo_inteiro(objeto, "cor")
		inteiro xabsolut = obj.obter_propriedade_tipo_inteiro(objeto, "xabsoluto")
		inteiro yabsolut = obj.obter_propriedade_tipo_inteiro(objeto, "yabsoluto")
		string += "\tTipo: " + TIPOS[tipo] + "\n"
		string += "\tX: " + x + "\n"
		string += "\tY: " + y + "\n"
		string += "\tW: " + w + "\n" 
		string += "\tH: " + h + "\n"
		string += "\tVisivel: " + visivel + "\n"
		string += "\tOpacidade: " + opacidade + "\n"
		string += "\tRotacao: " + rotacao + "\n"
		string += "\tCor: " + cor + "\n"
		string += "\tX absoluto: " + xabsolut + "\n"
		string += "\tY absoluto: " + yabsolut + "\n"
		string += + "\n}"
		retorne string
	}
	
	funcao logico teste_visibilidade(inteiro objeto) {
		relatar(RELATO_VERBOSE, "No pre render do objeto " + objeto_para_string(objeto))
		inteiro tipo = obj.obter_propriedade_tipo_inteiro(objeto, "tipo")
		logico visivel = obj.obter_propriedade_tipo_logico(objeto, "visivel")
		inteiro opacidad = obj.obter_propriedade_tipo_inteiro(objeto, "opacidade")
		se (nao visivel ou opacidade <= 0) { // Não renderiza caso o objeto esteja invisível
			relatar(RELATO_DEBUG, "Objeto " + objeto + " está invísivel")
			retorne falso
		}
		retorne verdadeiro
	}

	// Recalcula posição ou tamanho do objeto a depender de sua relação com o objeto pai
	// Acho que é melhor separar essa função em outras menores, antes que fique complexo de mais....
	funcao pre_renderizar_objeto(inteiro objeto) {
		se (nao teste_visibilidade(objeto)) {
			retorne
		}
		real x = obj.obter_propriedade_tipo_real(objeto, "x")
		real y = obj.obter_propriedade_tipo_real(objeto, "y")
		real h = obj.obter_propriedade_tipo_real(objeto, "h")
		real w = obj.obter_propriedade_tipo_real(objeto, "w")
		inteiro modo_x = obj.obter_propriedade_tipo_inteiro(objeto, "modox")
		inteiro modo_y = obj.obter_propriedade_tipo_inteiro(objeto, "modoy")
		inteiro modo_h = obj.obter_propriedade_tipo_inteiro(objeto, "modoh")
		inteiro modo_w = obj.obter_propriedade_tipo_inteiro(objeto, "modow")
		real pai_x = 0.0
		real pai_y = 0.0
		real pai_cx = 0.0
		real pai_cy = 0.0
		real pai_h = janela_altura
		real pai_w = janela_largura
		inteiro pai_xabsoluto = 0
		inteiro pai_yabsoluto = 0
		inteiro canvas_w = w
		inteiro canvas_h = h
		inteiro endereco_pai = receber_pai(objeto)
		se (checar_objeto_fraco(endereco_pai)) { // 0 indica que não existe um objeto
			pai_x = obj.obter_propriedade_tipo_real(endereco_pai, "x")
			pai_y = obj.obter_propriedade_tipo_real(endereco_pai, "y")
			pai_cx = obj.obter_propriedade_tipo_real(endereco_pai, "cameraX")
			pai_cy = obj.obter_propriedade_tipo_real(endereco_pai, "cameraY")
			pai_h = obj.obter_propriedade_tipo_real(endereco_pai, "h")
			pai_w = obj.obter_propriedade_tipo_real(endereco_pai, "w")
			pai_xabsoluto = obj.obter_propriedade_tipo_inteiro(endereco_pai, "xabsoluto")
			pai_yabsoluto = obj.obter_propriedade_tipo_inteiro(endereco_pai, "yabsoluto")
		}
		relatar(RELATO_VERBOSE, "Posicionamento de " + objeto + " no modo " + POSICOES[modo_x])
		relatar(RELATO_VERBOSE, "Posicionamento de " + objeto + " no modo " + POSICOES[modo_y])
		relatar(RELATO_VERBOSE, "Posicionamento de " + objeto + " no modo " + POSICOES[modo_h])
		relatar(RELATO_VERBOSE, "Posicionamento de " + objeto + " no modo " + POSICOES[modo_w])
		inteiro xabsolut = pai_xabsoluto + x
		inteiro yabsolut = pai_yabsoluto + y
		escolha(modo_x) {
			caso POSICAO_PX:
				// Por padrão o xabsolut e yabsolut vêm calculado no modo px
			caso POSICAO_RPAI:
				xabsolut = pai_xabsoluto + (clamp_real(x, 0, 1) * pai_w)
				pare
			caso POSICAO_ABSOLUTO:
				xabsolut = x
				pare
			caso contrario:
				relatar(RELATO_ERRO, "Modo de posicionamento não conhecido " + modo_x)
				pare
		}
		escolha(modo_y) {
			caso POSICAO_PX:
				// Por padrão o xabsolut e yabsolut vêm calculado no modo px
			caso POSICAO_RPAI:
				yabsolut = pai_yabsoluto + (clamp_real(y, 0, 1) * pai_h)
				pare
			caso POSICAO_ABSOLUTO:
				xabsolut = y
				pare
			caso contrario:
				relatar(RELATO_ERRO, "Modo de posicionamento não conhecido " + modo_y)
				pare
		}
		escolha(modo_h) {
			caso contrario:
				relatar(RELATO_ERRO, "Modo de posicionamento não conhecido " + modo_h)
				pare
		}
		escolha(modo_w) {
			caso contrario:
				relatar(RELATO_ERRO, "Modo de posicionamento não conhecido " + modo_w)
				pare
		}
		obj.atribuir_propriedade(objeto, "xabsoluto", xabsolut)
		obj.atribuir_propriedade(objeto, "yabsoluto", yabsolut)
		relatar(RELATO_VERBOSE, "h " + pai_h + " w " + pai_w + " xabs " + xabsolut + " yabs "  + yabsolut)
		inteiro relacao_posicao = colisao_quadrado_quadrado(pai_cx, pai_cy, pai_h, pai_w, x, y, h, w)
		logico continuar = verdadeiro
		escolha(relacao_posicao) {
			caso COLISAO_DENTRO:
				pare
			caso COLISAO_FORA://não renderiza pois estamos fora do corpo do pai
				continuar = falso
				pare
			caso COLISAO_DENTRO_FORA: // recalculamos nosso tamanho para ficarmos dentro do pai
				canvas_w = pai_cx + pai_w - x
				canvas_h = pai_cy + pai_h - y
				se (canvas_w <= 0 ou canvas_h <= 0) {
					 continuar = falso
				}
				pare
			caso COLISAO_FORA_DENTRO: // Por enquanto não lidamos com essa situação
				canvas_w = w - x + pai_cx
				canvas_h = h - y + pai_cy
				se (canvas_w <= 0 ou canvas_h <= 0) {
					 continuar = falso
				}
				pare
			caso contrario:
				relatar(RELATO_ERRO, "Ocorreu uma colisão impossível!")
				pare
		}
		se (continuar) {
			relatar(RELATO_VERBOSE, "Objeto será renderizado em x: " + xabsolut + " y: " + yabsolut)
			definir_opacidade(opacidade)
			renderizar_objeto(objeto, xabsolut, yabsolut, pai_cx, pai_cy, h, w, canvas_h, canvas_w)
			restaurar_configuracoes_graficas() // será que isso é realmente necessário?
			renderizar_filhos(objeto)
		} senao {
			relatar(RELATO_VERBOSE, "Objeto não renderizou pois está completamente fora de seu container " + objeto)
		}
	}

	funcao renderizar() {
		salvar_configuracoes_graficas()
		pre_renderizar()
		pre_renderizar_objeto(OBJETO_MESTRE)
		pos_renderizar()
		renderizar_final()
	}

	funcao renderizar_final() {
		para(inteiro i = 0; i < quantidade_imagens; i ++) {
			inteiro objeto_imagem = imagens[i]
			se (nao (objeto_imagem <= 0)) {
				inteiro imagem = obj.obter_propriedade_tipo_inteiro(objeto_imagem, "imagem")
				inteiro x = obj.obter_propriedade_tipo_inteiro(objeto_imagem, "x")
				inteiro y = obj.obter_propriedade_tipo_inteiro(objeto_imagem, "y")
				relatar(RELATO_VERBOSE, "Desenhando imagem " + imagem + " em x " + x + " em y " + y)
				g.desenhar_imagem(x, y, imagem)
				g.liberar_imagem(imagem)
				imagens[i] = 0
			}
		}
		quantidade_imagens = 0
		g.renderizar()
	}

	funcao pre_renderizar() {
	}

	funcao pos_renderizar() {
		para(inteiro i = 0; i < quantidade_objetos; i++) {
			objetos_processados[i] = 0
		}
	}

	funcao processar_mouse() {
		mouseX = mouse.posicao_x()
		mouseY = mouse.posicao_y()
		mouseE_pressionado = mouse.botao_pressionado(mouse.BOTAO_ESQUERDO)
		mouseM_pressionado = mouse.botao_pressionado(mouse.BOTAO_MEIO)
		mouseD_pressionado = mouse.botao_pressionado(mouse.BOTAO_DIREITO)
	}

	funcao processar_teclado() {
		
	}

	funcao processar_tela() {
		
	}

	funcao definir_padroes() {
		definir_opacidade(ATUAL_OPACIDADE)
		definir_rotacao(ATUAL_ROTACAO)
		definir_cor(ATUAL_COR)
		definir_estilo(ATUAL_ITALICO, ATUAL_NEGRITO, ATUAL_SUBLINHADO)
		definir_fonte(ATUAL_FONTE)
		definir_tamanho_fonte(ATUAL_TAMANHO_FONTE)
	}
	// Validações de propriedades
	const inteiro VALIDACAO_PORCENTAGEM_DECIMAL = 0
	const inteiro VALIDACAO_PORCENTAGEM_PORCENTO = 1
	const inteiro VALIDACAO_PORCENTAGEM_INVALIDO = 2
	funcao inteiro validar_porcentagem_limite(real valor, real limite) {
		se (valor >= 0 e valor <= limite) {
			retorne VALIDACAO_PORCENTAGEM_DECIMAL
		} senao se (valor >= 0 e valor <= limite * 100) {
			retorne VALIDACAO_PORCENTAGEM_PORCENTO
		}
		retorne VALIDACAO_PORCENTAGEM_INVALIDO
	}
	
	// Usar sempre essas funções quando for manipular objetos
	funcao atribuir_propriedade_inteiro(inteiro objeto, cadeia p, inteiro i) {
		obj.atribuir_propriedade(objeto, p, i)
		notificarMudancas()
	}
	funcao atribuir_propriedade_real(inteiro objeto, cadeia p, real r) {
		obj.atribuir_propriedade(objeto, p, r)
		notificarMudancas()
	}
	funcao atribuir_propriedade_cadeia(inteiro objeto, cadeia p, cadeia c) {
		obj.atribuir_propriedade(objeto, p, c)
		notificarMudancas()
	}
	funcao atribuir_propriedade_caracter(inteiro objeto,cadeia p,  caracter c) {
		obj.atribuir_propriedade(objeto, p, c)
		notificarMudancas()
	}
	funcao atribuir_propriedade_logico(inteiro objeto, cadeia p, logico l) {
		obj.atribuir_propriedade(objeto, p, l)
		notificarMudancas()
	}
	
	funcao atribuir_x(inteiro objeto, real x) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_real(objeto, "x", x)
		}
	}

	funcao atribuir_y(inteiro objeto, real y) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_real(objeto, "y", y)
		}
	}

	funcao atribuir_w(inteiro objeto, real w) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_real(objeto, "w", w)
		}
	}

	funcao atribuir_h(inteiro objeto, real h) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_real(objeto, "h", h)
		}
	}

	funcao atribuir_cameraX(inteiro objeto, real cameraX) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_real(objeto, "cameraX", cameraX)
		}
	}

	funcao atribuir_cameraY(inteiro objeto, real cameraY) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_real(objeto, "cameraY", cameraY)
		}
	}
	
	funcao atribuir_visivel(inteiro objeto, logico visivel) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_logico(objeto, "visivel", visivel)
		}
	}

	funcao atribuir_foco(inteiro objeto, logico foco) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_logico(objeto, "foco", foco)
		}
	}

	funcao atribuir_opacidade(inteiro objeto, inteiro o) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_inteiro(objeto, "opacidade", o)
		}
	}

	funcao atribuir_rotacao(inteiro objeto, inteiro r) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_inteiro(objeto, "rotacao", r)
		}
	}

	funcao atribuir_cor(inteiro objeto, inteiro c) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_inteiro(objeto, "cor", c)
		}
	}

	funcao inicializar_graficos() {
		g.iniciar_modo_grafico(verdadeiro)
		janela_largura = g.largura_tela()
		janela_altura = g.altura_tela()
		g.definir_dimensoes_janela(janela_largura, janela_altura)
		g.definir_titulo_janela("Gráficos")
	}

	funcao inicializar_objetos() {
		criar_objeto_mestre() // nenhum objeto pode ter ID = 0, então nos livramos dele no ínicio.
	}

	funcao biblioteca_ui_finalizar() {
		g.encerrar_modo_grafico()
	}


	funcao inicializar_biblioteca_ui() {
		inicializar_graficos()
		inicializar_objetos() // Se remover essa linha, é problema.
		definir_padroes()
	}

	funcao biblioteca_ui_tick() {
		processar_tela()
		processar_mouse()
		processar_teclado()
		se(houveramMudancas) {
			renderizar()
			houveramMudancas = falso
		}
	}


	funcao inicio()
 	{
 		inicializar_biblioteca_ui()
		definir_fonte("Roboto")
		inteiro container = criar_retangulo(0, 0, 100, 100)
		atribuir_cor(container, g.COR_AMARELO)
		inteiro texto = criar_caixa_texto("Teste")
		adotar(container, texto)
		inserir_objeto(container)
		enquanto (nao kb.tecla_pressionada(kb.TECLA_ESC))
		{
			biblioteca_ui_tick()			
		}
		biblioteca_ui_finalizar()
	}

	
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 4607; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz;
 */