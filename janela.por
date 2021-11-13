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


	// DEBUGGING
	const inteiro RELATO_NORMAL = 0
	const inteiro RELATO_AVISO = 1
	const inteiro RELATO_ERRO = 2
	const inteiro RELATO_DEBUG = 3
	const inteiro RELATO_VERBOSE = 4

	inteiro NIVEL_RELATO = RELATO_AVISO

	cadeia RELATOS_DISPLAY[] = {"NORMAL",  "AVISO", "ERRO", "DEBUG", "VERBOSE"}


	inteiro tempo_antes = 0
	inteiro tempo_delta = 0
	inteiro tempo_frame = 0
	inteiro quadros = 0
	real qps = 0.0
	inteiro qps_duracao = segundos(1)
	inteiro qps_inicio = 0
	const inteiro qps_maximo = 300
	inteiro qps_limite = -1
	
	logico depuracao = verdadeiro

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


	//TEMPO
	const inteiro ms_por_segundo = 1000
	const inteiro segundos_por_min = 60
	const inteiro min_por_hora = 60
	const inteiro horas_por_dia = 24
	const inteiro dias_por_ano = 365
	
	funcao inteiro segundos(inteiro s) {
		retorne s * ms_por_segundo
	}

	funcao inteiro minutos(inteiro m) {
		retorne segundos(m * segundos_por_min)
	}

	funcao inteiro horas(inteiro h) {
		retorne minutos(h * min_por_hora)
	}

	funcao inteiro dias(inteiro d) {
		retorne horas(d * horas_por_dia)
	}

	funcao inteiro anos(inteiro a) {
		retorne dias(a * dias_por_ano)
	}

	funcao real ms_em_segundos(inteiro ms) {
		retorne ms / ms_por_segundo
	}

	funcao real ms_em_minutos(inteiro ms) {
		retorne ms_em_segundos(ms)/segundos_por_min
	}

	funcao real ms_em_horas(inteiro ms) {
		retorne ms_em_minutos(ms)/min_por_hora
	}

	funcao real ms_em_dias(inteiro ms) {
		retorne ms_em_horas(ms)/horas_por_dia
	}
	
	funcao inteiro ms_em_anos(inteiro ms) {
		retorne ms_em_dias(ms)/dias_por_ano
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
	const inteiro PADROES_PAI = -1
	const real PADROES_X = 0.0
	const real PADROES_Y = 0.0
	const real PADROES_H = 0.0
	const real PADROES_W = 0.0
	const logico PADROES_VISIVEL = verdadeiro
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
	inteiro ATUAL_PAI = PADROES_PAI
	real ATUAL_X = PADROES_X
	real ATUAL_Y = PADROES_Y
	real ATUAL_H = PADROES_H
	real ATUAL_W = PADROES_W
	logico ATUAL_VISIVEL = PADROES_VISIVEL
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
	const inteiro POSICIONAMENTO_PX = 0
	const inteiro POSICIONAMENTO_RPAI = 1

	const cadeia POSICIONAMENTOS[] = {"PIXEL RELATIVA AO PAI", "PORCENTAGEM RELATIVA AO PAI"}
	//Tipos de dimensionamento
	const inteiro DIMENSIONAMENTO_PX = 0
	const inteiro DIMENSIONAMENTO_RPAI = 1

	const cadeia DIMENSIONAMENTOS[] = {"PIXEL", "PORCENTAGEM RELATIVA AO PAI"}
	
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
			relatar(RELATO_VERBOSE, "Colisão do tipo " + COLISOES[COLISAO_DENTRO])
			retorne COLISAO_DENTRO
		} senao se (ponto_esquerdo_superior_dentro e nao ponto_direito_inferior_dentro) {
			relatar(RELATO_VERBOSE, "Colisão do tipo " + COLISOES[COLISAO_DENTRO_FORA])
			retorne COLISAO_DENTRO_FORA
		} senao se (nao ponto_esquerdo_superior_dentro e ponto_direito_inferior_dentro) {
			relatar(RELATO_VERBOSE, "Colisão do tipo " + COLISOES[COLISAO_FORA_DENTRO])
			retorne COLISAO_FORA_DENTRO
		} senao se (nao ponto_esquerdo_superior_dentro e nao ponto_direito_inferior_dentro) {
			relatar(RELATO_VERBOSE, "Colisão do tipo " + COLISOES[COLISAO_FORA])
			retorne COLISAO_FORA
		}
		retorne COLISAO_IMPOSSIVEL
	}

	funcao logico checar_objeto_mestre(inteiro objeto) {
		retorne objeto == OBJETO_MESTRE
	}

	funcao logico checar_objeto_fraco(inteiro objeto) {
		se (objeto < 0 ou objeto >= MAXIMO_DE_ELEMENTOS) {
			relatar(RELATO_ERRO, "Tentativa de usar objeto inválido " + objeto)
			retorne falso
		}
		retorne verdadeiro
	}

	funcao logico checar_tipo_objeto(inteiro objeto, inteiro tipo) {
		se (checar_objeto_fraco(objeto)) {
			retorne obj.obter_propriedade_tipo_inteiro(objeto, "tipo") == tipo
		}
		retorne falso
	}

	funcao notificar_mudancas() {
		houveramMudancas = verdadeiro
	}

	funcao inserir_objeto(inteiro objeto) {
		adotar(OBJETO_MESTRE, objeto)
		quantidade_objetos += 1
		notificar_mudancas()
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
		obj.atribuir_propriedade(objeto, "x", ATUAL_X)
		obj.atribuir_propriedade(objeto, "modox", ATUAL_POSICIONAMENTO)
		obj.atribuir_propriedade(objeto, "y", ATUAL_Y)
		obj.atribuir_propriedade(objeto, "modoy", ATUAL_POSICIONAMENTO)
		obj.atribuir_propriedade(objeto, "w", ATUAL_W)
		obj.atribuir_propriedade(objeto, "modow", ATUAL_DIMENSIONAMENTO)
		obj.atribuir_propriedade(objeto, "h", ATUAL_H)
		obj.atribuir_propriedade(objeto, "modoh", ATUAL_DIMENSIONAMENTO)
		obj.atribuir_propriedade(objeto, "cameraX", 0.0)
		obj.atribuir_propriedade(objeto, "cameraY", 0.0)
		obj.atribuir_propriedade(objeto, "visivel", verdadeiro)
		obj.atribuir_propriedade(objeto, "foco", falso)
		obj.atribuir_propriedade(objeto, "tipo", tipo)
		obj.atribuir_propriedade(objeto, "pai", -1)
		obj.atribuir_propriedade(objeto, "opacidade", ATUAL_OPACIDADE)
		obj.atribuir_propriedade(objeto, "rotacao", ATUAL_ROTACAO)
		obj.atribuir_propriedade(objeto, "cor", ATUAL_COR)
		//variaveis do sistema de de estilização, não alterar manualmente esses valores pois são calculados
		//automáticamente.
		obj.atribuir_propriedade(objeto, "__x", 0)
		obj.atribuir_propriedade(objeto, "__y", 0)
		obj.atribuir_propriedade(objeto, "__h", 0)
		obj.atribuir_propriedade(objeto, "__w", 0)
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


	funcao renderizar_retangulo(inteiro objeto, inteiro x, inteiro y, inteiro h, inteiro w) {
		logico preencher = obj.obter_propriedade_tipo_logico(objeto, "preencher")
		logico arredondado = obj.obter_propriedade_tipo_logico(objeto, "arredondado")
		g.desenhar_retangulo(x, y, w, h, arredondado, preencher)
		relatar(RELATO_VERBOSE, "Desenhando retângulo " + objeto_para_string(objeto) + "\npreencher " + preencher)
	}

	funcao renderizar_caixa_texto(inteiro objeto, inteiro x, inteiro y, inteiro h, inteiro w) {
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

	
	funcao renderizar_botao(inteiro objeto, inteiro x, inteiro y, inteiro h, inteiro w) {
		renderizar_retangulo(objeto, x, y, h, w)
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
		caso TIPOS_MESTRE:
			renderizar_retangulo(objeto, x, y, h, w)
			pare
		caso contrario:
			relatar(RELATO_ERRO, "Houve a tentativa de renderizar um tipo desconhecido com enum: " + tipo)
			pare
		}
	}
	
	// Renderiza um objeto num buffer para que esse buffer nos ajude com desenhos parciais, depois renderiza para a tela
	funcao renderizar_objeto(inteiro objeto, inteiro xabsoluto, inteiro yabsoluto, inteiro cx, inteiro cy, inteiro h, inteiro w, inteiro canvas_h, inteiro canvas_w) {
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
		inteiro __x = obj.obter_propriedade_tipo_inteiro(objeto, "__x")
		inteiro __y = obj.obter_propriedade_tipo_inteiro(objeto, "__y")
		inteiro __h = obj.obter_propriedade_tipo_inteiro(objeto, "__h")
		inteiro __w = obj.obter_propriedade_tipo_inteiro(objeto, "__w")
		string += "\tTipo: " + TIPOS[tipo] + "\n"
		string += "\tX: " + x + "\n"
		string += "\tY: " + y + "\n"
		string += "\tW: " + w + "\n" 
		string += "\tH: " + h + "\n"
		string += "\tVisivel: " + visivel + "\n"
		string += "\tOpacidade: " + opacidade + "\n"
		string += "\tRotacao: " + rotacao + "\n"
		string += "\tCor: " + cor + "\n"
		string += "\tX absoluto: " + __x + "\n"
		string += "\tY absoluto: " + __x + "\n"
		string += "\tH absoluto: " + __h + "\n"
		string += "\tW absoluto: " + __w + "\n"
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

	funcao calcular_propriedades_tipo(inteiro objeto, inteiro tipo) {
		escolha (tipo) {
			caso TIPOS_CAIXA_TEXTO:
				pare
			caso contrario:
				pare
		}
	}

	funcao calcular_propriedades(inteiro objeto) {
		real x = obj.obter_propriedade_tipo_real(objeto, "x")
		real y = obj.obter_propriedade_tipo_real(objeto, "y")
		real h = obj.obter_propriedade_tipo_real(objeto, "h")
		real w = obj.obter_propriedade_tipo_real(objeto, "w")
		inteiro modo_x = obj.obter_propriedade_tipo_inteiro(objeto, "modox")
		inteiro modo_y = obj.obter_propriedade_tipo_inteiro(objeto, "modoy")
		inteiro modo_h = obj.obter_propriedade_tipo_inteiro(objeto, "modoh")
		inteiro modo_w = obj.obter_propriedade_tipo_inteiro(objeto, "modow")
		inteiro pai_x = 0
		inteiro pai_y = 0
		inteiro pai_h = 0
		inteiro pai_w = 0
		inteiro x_calculado = 0
		inteiro y_calculado = 0
		inteiro h_calculado = 0
		inteiro w_calculado = 0
		inteiro endereco_pai = receber_pai(objeto)
		relatar(RELATO_VERBOSE, "Endereco pai " + endereco_pai)
		se (checar_objeto_fraco(endereco_pai)) { // 0 indica que não existe um objeto
			pai_x = obj.obter_propriedade_tipo_inteiro(endereco_pai, "__x")
			pai_y = obj.obter_propriedade_tipo_inteiro(endereco_pai, "__y")
			pai_h = obj.obter_propriedade_tipo_inteiro(endereco_pai, "__h")
			pai_w = obj.obter_propriedade_tipo_inteiro(endereco_pai, "__w")
			relatar(RELATO_VERBOSE, "Objeto " + objeto_para_string(endereco_pai))
		}
		relatar(RELATO_VERBOSE, "Absoluto pai w " + pai_w)
		x_calculado = pai_x + x
		y_calculado = pai_y + y
		escolha(modo_x) {
			caso POSICIONAMENTO_PX:
				// Por padrão o xabsolut e yabsolut vêm calculado no modo px
				pare
			caso POSICIONAMENTO_RPAI:
				x_calculado = pai_x + (clamp_real(x, 0, 1) * pai_w)
				pare
			caso contrario:
				relatar(RELATO_ERRO, "Modo de posicionamento não conhecido " + modo_x)
				pare
		}
		escolha(modo_y) {
			caso POSICIONAMENTO_PX:
				// Por padrão o xabsolut e yabsolut vêm calculado no modo px
				pare
			caso POSICIONAMENTO_RPAI:
				y_calculado = pai_y + (clamp_real(y, 0, 1) * pai_h)
				pare
			caso contrario:
				relatar(RELATO_ERRO, "Modo de posicionamento não conhecido " + modo_y)
				pare
		}
		escolha(modo_h) {
			caso DIMENSIONAMENTO_PX:
				h_calculado = h
				pare
			caso DIMENSIONAMENTO_RPAI:
				h_calculado = pai_h * clamp_real(h, 0, 1)
				pare
			caso contrario:
				relatar(RELATO_ERRO, "Modo de posicionamento não conhecido " + modo_h)
				pare
		}
		escolha(modo_w) {
			caso DIMENSIONAMENTO_PX:
				w_calculado = w
				pare
			caso DIMENSIONAMENTO_RPAI:
				w_calculado = pai_w * clamp_real(w, 0, 1)
				relatar(RELATO_VERBOSE, "W calculado " + w_calculado + " clamp " + clamp_real(w,0 , 1))
				pare
			caso contrario:
				relatar(RELATO_ERRO, "Modo de posicionamento não conhecido " + modo_w)
				pare
		}
		// Atribuição manual
		relatar(RELATO_VERBOSE, "X calculado " + x_calculado + " Y calculado " + y_calculado + "H calculado " + h_calculado + "W calculado " + w_calculado)
		obj.atribuir_propriedade(objeto, "__x", x_calculado)
		obj.atribuir_propriedade(objeto, "__y", y_calculado)
		obj.atribuir_propriedade(objeto, "__h", h_calculado)
		obj.atribuir_propriedade(objeto, "__w", w_calculado)
		
		notificar_mudancas()
	}

	// Recalcula posição ou tamanho do objeto a depender de sua relação com o objeto pai
	// Acho que é melhor separar essa função em outras menores, antes que fique complexo de mais....
	funcao pre_renderizar_objeto(inteiro objeto) {
		se (nao teste_visibilidade(objeto)) {
			retorne
		}
		calcular_propriedades(objeto)
		inteiro __x = obj.obter_propriedade_tipo_inteiro(objeto, "__x")
		inteiro __y = obj.obter_propriedade_tipo_inteiro(objeto, "__y")
		inteiro __h = obj.obter_propriedade_tipo_inteiro(objeto, "__h")
		inteiro __w = obj.obter_propriedade_tipo_inteiro(objeto, "__w")
		inteiro pai_x = 0
		inteiro pai_y = 0
		inteiro pai_h = 0
		inteiro pai_w = 0
		real pai_cx = 0
		real pai_cy = 0
		inteiro canvas_h = 0
		inteiro canvas_w = 0
		inteiro endereco_pai = receber_pai(objeto)
		se (checar_objeto_fraco(endereco_pai)) { // 0 indica que não existe um objeto
			pai_x = obj.obter_propriedade_tipo_inteiro(objeto, "__x")
			pai_y = obj.obter_propriedade_tipo_inteiro(objeto, "__y")
			pai_h = obj.obter_propriedade_tipo_inteiro(objeto, "__h")
			pai_w = obj.obter_propriedade_tipo_inteiro(objeto, "__w")
			pai_cx = obj.obter_propriedade_tipo_real(objeto, "cameraX")
			pai_cy = obj.obter_propriedade_tipo_real(objeto, "cameraY")
		}
		inteiro relacao_posicao = colisao_quadrado_quadrado(pai_x, pai_y, pai_h, pai_w, __x, __y, __h, __w)
		logico continuar = verdadeiro
		canvas_h = __h
		canvas_w = __w
		se (nao checar_objeto_mestre(objeto)) {
			escolha(relacao_posicao) {
			caso COLISAO_DENTRO:
				pare
			caso COLISAO_FORA://não renderiza pois estamos fora do corpo do pai
				continuar = falso
				pare
			caso COLISAO_DENTRO_FORA: // recalculamos nosso tamanho para ficarmos dentro do pai
				canvas_w = pai_cx + pai_w - __x
				canvas_h = pai_cy + pai_h - __y
				se (canvas_w <= 0 ou canvas_h <= 0) {
					 continuar = falso
				}
				pare
			caso COLISAO_FORA_DENTRO: // Por enquanto não lidamos com essa situação
				canvas_w = __w - __x + pai_cx
				canvas_h = __h - __y + pai_cy
				se (canvas_w <= 0 ou canvas_h <= 0) {
					 continuar = falso
				}
				pare
			caso contrario:
				relatar(RELATO_ERRO, "Ocorreu uma colisão impossível!")
				pare
			}
		}
		se (continuar ou checar_objeto_mestre(objeto)) {
			relatar(RELATO_VERBOSE, "Objeto será renderizado em x: " + __x + " y: " + __y)
			definir_opacidade(opacidade)
			renderizar_objeto(objeto, __x, __y, pai_cx, pai_cy, __h, __w, canvas_h, canvas_w)
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

	funcao processar_depuracao() {
		se (depuracao) {
			quadros +=1
			inteiro periodo = tempo_antes - qps_inicio
			se (periodo >= qps_duracao) {
				qps = quadros
				qps_inicio = tempo_antes
				relatar(RELATO_AVISO, "QPS: " + quadros )
				quadros = 0
			}
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
		inteiro h = g.altura_tela()
		inteiro w = g.largura_tela()
		se (h != janela_altura ou w != janela_largura) {
			atribuir_h(OBJETO_MESTRE, h)
			atribuir_w(OBJETO_MESTRE, w)
			notificar_mudancas()
		}
	}

	funcao processar_inicial() {
		inteiro agora = util.tempo_decorrido()
		tempo_delta = agora - tempo_antes
		tempo_antes = agora
	}

	funcao processar_final() {
		inteiro agora = util.tempo_decorrido()
		tempo_frame = agora - tempo_antes
		inteiro tempo_limite = segundos(1)/qps_maximo
		inteiro tempo_restante = tempo_limite - tempo_frame
		se (qps_limite > 0 e qps_limite != 0) {
			tempo_limite = segundos(1)/qps_limite
			tempo_restante = tempo_limite - tempo_frame
		}
		se (tempo_restante > 0) {
			util.aguarde(tempo_restante)
		}
	}

	funcao processar_generico() {}

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
		notificar_mudancas()
	}
	funcao atribuir_propriedade_real(inteiro objeto, cadeia p, real r) {
		obj.atribuir_propriedade(objeto, p, r)
		notificar_mudancas()
	}
	funcao atribuir_propriedade_cadeia(inteiro objeto, cadeia p, cadeia c) {
		obj.atribuir_propriedade(objeto, p, c)
		notificar_mudancas()
	}
	funcao atribuir_propriedade_caracter(inteiro objeto,cadeia p,  caracter c) {
		obj.atribuir_propriedade(objeto, p, c)
		notificar_mudancas()
	}
	funcao atribuir_propriedade_logico(inteiro objeto, cadeia p, logico l) {
		obj.atribuir_propriedade(objeto, p, l)
		notificar_mudancas()
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

	funcao atribuir_modox(inteiro objeto, inteiro modo) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_inteiro(objeto, "modox", modo)
		}
	}

	funcao atribuir_modoy(inteiro objeto, inteiro modo) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_inteiro(objeto, "modoy", modo)
		}
	}

	funcao atribuir_modoh(inteiro objeto, inteiro modo) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_inteiro(objeto, "modoh", modo)
		}
	}

	funcao atribuir_modow(inteiro objeto, inteiro modo) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_inteiro(objeto, "modow", modo)
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

	funcao atribuir_texto(inteiro objeto, cadeia t) {
		se (checar_objeto_fraco(objeto) e checar_tipo_objeto(objeto, TIPOS_CAIXA_TEXTO)) {
			atribuir_propriedade_cadeia(objeto, "text", t)
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
		processar_inicial()
		processar_mouse()
		processar_teclado()
		processar_generico()
		processar_tela()
		processar_depuracao()
		se(houveramMudancas) {
			renderizar()
			houveramMudancas = falso
		}
		processar_final()
	}
	
	funcao inicio()
 	{
 		inicializar_biblioteca_ui()
		definir_fonte("Roboto")
		inteiro fps = criar_caixa_texto("FPS: 0")
		atribuir_cor(fps, g.COR_PRETO)
		inserir_objeto(fps)
		inteiro botao = criar_botao("Teste1", "", 0, 0, 0.6, 0.6)
		inteiro botao2 = criar_botao("Teste2", "", 0, 0, 0.5, 0.5)
		inteiro botao3 = criar_botao("Teste3", "", 0, 0, 0.5, 0.5)
		inteiro botao4 = criar_botao("Teste4", "", 0, 0, 0.5, 0.5)
		atribuir_modoh(botao, DIMENSIONAMENTO_RPAI)
		atribuir_modow(botao, DIMENSIONAMENTO_RPAI)
		atribuir_cor(botao, g.COR_AZUL)
		atribuir_modoh(botao2, DIMENSIONAMENTO_RPAI)
		atribuir_modow(botao2, DIMENSIONAMENTO_RPAI)
		atribuir_cor(botao2, g.COR_PRETO)
		atribuir_modoh(botao3, DIMENSIONAMENTO_RPAI)
		atribuir_modow(botao3, DIMENSIONAMENTO_RPAI)
		atribuir_cor(botao3, g.COR_AMARELO)
		atribuir_modoh(botao4, DIMENSIONAMENTO_RPAI)
		atribuir_modow(botao4, DIMENSIONAMENTO_RPAI)
		atribuir_cor(botao4, g.COR_VERMELHO)
		//inserir_objeto(botao)
		adotar(botao, botao2)
		adotar(botao2, botao3)
		adotar(botao3, botao4)
		enquanto (nao kb.tecla_pressionada(kb.TECLA_ESC))
		{	
			atribuir_texto(fps, "FPS: " + qps)
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
 * @POSICAO-CURSOR = 21426; 
 * @DOBRAMENTO-CODIGO = [89, 93, 97, 101, 105];
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz;
 */