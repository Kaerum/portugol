programa
{
	inclua biblioteca Graficos --> gf
	inclua biblioteca Teclado --> kb
	inclua biblioteca Matematica --> mt
	inclua biblioteca Tipos --> tp
	inclua biblioteca Util --> ut
	inclua biblioteca Mouse --> mu
	inclua biblioteca Objetos --> ob

	//CORES
	const inteiro COR_BACKGROUND_LIGHT_GRAY = 0xeef0f1
	const inteiro COR_BACKGROUND_GRAY = 0xe0e0e0
	const inteiro COR_PRIMARY = -1610948
	const inteiro COR_PRIMARY_LIGHT = -25751
	const inteiro COR_PRIMARY_DARK = -5293040
	const inteiro COR_SECONDARY = -12868914
	const inteiro COR_PRETO = 0

	// DEBUGGING
	const inteiro RELATO_NORMAL = 0
	const inteiro RELATO_AVISO = 1
	const inteiro RELATO_ERRO = 2
	const inteiro RELATO_DEBUG = 3
	const inteiro RELATO_VERBOSE = 4

	inteiro NIVEL_RELATO = RELATO_DEBUG

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
	inteiro cronometro_inicio = 0

	// Utilidades
	funcao cronometro_comecar() {
		cronometro_inicio = ut.tempo_decorrido()
	}

	funcao cronometro_finalizar(cadeia id) {
		relatar(RELATO_DEBUG, "[" + id + "]" + " Tempo decorrido " + (ut.tempo_decorrido() - cronometro_inicio))
		cronometro_inicio = 0
	}
	
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

	// Admistração de objetos
	inteiro OBJETO_MESTRE = -1
	inteiro OBJETO_FOCADO = 0
	const inteiro MAXIMO_DE_PAIS = 3000
	const inteiro MAXIMO_DE_FILHOS = 200

	inteiro quantidade_filhos[MAXIMO_DE_PAIS]
	inteiro filhos[MAXIMO_DE_PAIS][MAXIMO_DE_FILHOS]
	inteiro nomeados = ob.criar_objeto()

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

	// Mouse
	const inteiro MOUSE_ESQUERDO = 0
	const inteiro MOUSE_MEIO = 1
	const inteiro MOUSE_DIREITO = 2
	const inteiro LIMITE_MOUSE_OBJETOS = 128
	logico mouse_pressionado[] = {falso, falso, falso}
	logico mouse_carregando[] = {falso, falso, falso}
	inteiro mouseX = 0
	inteiro mouseY = 0
	inteiro mouse_sobre = 0
	// Mouse frame anterior
	logico mouse_pressionado_antes[] = {falso, falso, falso}
	logico mouse_carregando_antes[] = {falso, falso, falso}
	inteiro mouseX_antes = 0
	inteiro mouseY_antes = 0
	inteiro mouse_sobre_antes = 0
	inteiro quantidade_mouse_pressionado_sobre = 0
	inteiro mouse_pressionado_sobre[LIMITE_MOUSE_OBJETOS]
	inteiro quantidade_mouse_pressionado_sobre_antes = 0
	inteiro mouse_pressionado_sobre_antes[LIMITE_MOUSE_OBJETOS]

	// Eventos
	const inteiro EVENTO_MOUSE_ESQUERDO_PRESSIONAR = 0
	const inteiro EVENTO_MOUSE_ESQUERDO_SOLTAR = 1
	const inteiro EVENTO_MOUSE_ESQUERDO_CLICAR = 2
	const inteiro EVENTO_MOUSE_MEIO_PRESSIONAR = 3
	const inteiro EVENTO_MOUSE_MEIO_SOLTAR = 4
	const inteiro EVENTO_MOUSE_MEIO_CLICAR = 5
	const inteiro EVENTO_MOUSE_DIREITO_PRESSIONAR = 6
	const inteiro EVENTO_MOUSE_DIREITO_SOLTAR = 7
	const inteiro EVENTO_MOUSE_DIREITO_CLICAR = 8
	const inteiro EVENTO_MOUSE_MOVER = 9
	const inteiro LIMITE_EVENTOS = 4096
	const inteiro LIMITE_ARGUMENTOS = 10
	inteiro quantidade_eventos = 0
	/*
		Limpa-se todos os x nos eventos no ínicio de cada tick
	*/
	inteiro eventos [LIMITE_EVENTOS]
	

	// Padrões de estilização
	const logico PADROES_ARREDONDADO = falso
	const logico PADROES_PREENCHER = verdadeiro
	const inteiro PADROES_OPACIDADE = 255
	const inteiro PADROES_ROTACAO = 0
	const inteiro PADROES_COR = -1
	const inteiro PADROES_COR_TEXTO = 0
	const inteiro PADROES_OPACIDADE_TEXTO = 230
	const inteiro PADROES_POSICIONAMENTO = 1
	const inteiro PADROES_DIMENSIONAMENTO = 1
	const inteiro PADROES_PAI = -1
	const real PADROES_X = 0.0
	const real PADROES_Y = 0.0
	const real PADROES_H = 0.0
	const real PADROES_W = 0.0
	const inteiro PADROES_MARGEM_TOPO = 0
	const inteiro PADROES_MARGEM_ESQUERDA = 0	
	const logico PADROES_VISIVEL = verdadeiro
	// Caixas de texto
	const logico PADROES_ITALICO = falso
	const logico PADROES_NEGRITO = verdadeiro
	const logico PADROES_SUBLINHADO = falso
	const cadeia PADROES_FONTE = "Arial"
	const real PADROES_TAMANHO_FONTE = 16.0

	// Valores atuais de estilização
	logico ATUAL_ARREDONDADO = PADROES_ARREDONDADO
	logico ATUAL_PREENCHER = PADROES_PREENCHER
	inteiro ATUAL_OPACIDADE = PADROES_OPACIDADE
	inteiro ATUAL_ROTACAO = PADROES_ROTACAO
	inteiro ATUAL_COR = PADROES_COR
	inteiro ATUAL_COR_TEXTO = PADROES_COR_TEXTO
	inteiro ATUAL_OPACIDADE_TEXTO = PADROES_OPACIDADE_TEXTO
	inteiro ATUAL_POSICIONAMENTO = PADROES_POSICIONAMENTO
	inteiro ATUAL_DIMENSIONAMENTO = PADROES_DIMENSIONAMENTO
	inteiro ATUAL_PAI = PADROES_PAI
	real ATUAL_X = PADROES_X
	real ATUAL_Y = PADROES_Y
	real ATUAL_H = PADROES_H
	real ATUAL_W = PADROES_W
	inteiro ATUAL_MARGEM_TOPO = PADROES_MARGEM_TOPO
	inteiro ATUAL_MARGEM_ESQUERDA = PADROES_MARGEM_ESQUERDA
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
		gf.definir_opacidade(opacidade)
	}
	inteiro rotacao = PADROES_ROTACAO
	funcao definir_rotacao(inteiro r) {
		rotacao = r
		gf.definir_rotacao(rotacao)
	}
	inteiro cor = PADROES_COR
	funcao definir_cor(inteiro c) {
		cor = c
		gf.definir_cor(cor)
	}
	logico italico = PADROES_ITALICO
	funcao definir_italico(logico i) {
		italico = i
		gf.definir_estilo_texto(italico, negrito, sublinhado)
	}
	logico negrito = PADROES_NEGRITO
	funcao definir_negrito(logico n) {
		negrito = n
		gf.definir_estilo_texto(italico, negrito, sublinhado)
	}
	logico sublinhado = PADROES_SUBLINHADO
	funcao definir_sublinhado(logico s) {
		sublinhado = s
		gf.definir_estilo_texto(italico, negrito, sublinhado)
	}
	funcao definir_estilo(logico i, logico n, logico s) {
		italico = i
		sublinhado = s
		negrito = n
		gf.definir_estilo_texto(italico, negrito, sublinhado)
	}
	cadeia fonte = PADROES_FONTE
	funcao definir_fonte(cadeia f) {
		fonte = f
		gf.definir_fonte_texto(f)
	}
	real tamanho_fonte = PADROES_TAMANHO_FONTE
	funcao definir_tamanho_fonte(real t) {
		tamanho_fonte = t
		gf.definir_tamanho_texto(tamanho_fonte)
	}
	
	funcao definir_janela_altura(inteiro a) {
		gf.definir_dimensoes_janela(janela_largura, a)
	}
	
	funcao definir_janela_largura(inteiro l) {
		gf.definir_dimensoes_janela(l, janela_altura)
	}

	funcao definir_janela_dimensoes(inteiro l, inteiro a) {
		gf.definir_dimensoes_janela(l, a)
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
		se (checar_objeto_fraco(objeto)) {
			retorne ob.obter_propriedade_tipo_inteiro(objeto, "pai")	
		}
		retorne -1
	}

	funcao vazio inserir_pai(inteiro filho, inteiro pai) {
		ob.atribuir_propriedade(filho, "pai", pai)
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
			relatar(RELATO_VERBOSE, "Inserimos o filho " + filho + " em " + pai)
		}
		retorne verdadeiro
	}

	funcao logico colisao_retangulo_ponto(inteiro x, inteiro y, inteiro h, inteiro w, inteiro x2, inteiro y2) {
		retorne x2 >= x e x2 <= x + w e y2 >= y e y2 <= y + h
	}

	funcao inteiro colisao_retangulo_retangulo(inteiro x, inteiro y, inteiro h, inteiro w, inteiro x2, inteiro y2, inteiro h2, inteiro w2) {
		// Incompleto...
		logico xy = colisao_retangulo_ponto(x, y, h, w, x2, y2)
		logico xh = colisao_retangulo_ponto(x, y, h, w, x2, y2 + h2)
		logico wh = colisao_retangulo_ponto(x, y, h, w, x2 + w2, y2 + h2)
		logico wy = colisao_retangulo_ponto(x, y, h, w, x2 + w2, y2)
		inteiro quantidade = 0
		se (xy) {
			quantidade += 1
		}
		se (xh) {
			quantidade += 1
		}
		se (wh) {
			quantidade += 1
		}
		se (wy) {
			quantidade += 1
		}
		se (quantidade >= 3) {
			retorne COLISAO_DENTRO
		} senao se ( quantidade >= 1) {
			se (xy) {
				retorne COLISAO_DENTRO_FORA
			} senao {
				retorne COLISAO_FORA_DENTRO
			}
		} senao {
			retorne COLISAO_FORA
		}
	}

	funcao logico checar_objeto_mestre(inteiro objeto) {
		retorne objeto == OBJETO_MESTRE
	}

	funcao logico checar_objeto_fraco(inteiro objeto) {
		se (objeto < 0 ou objeto >= MAXIMO_DE_ELEMENTOS) {
			relatar(RELATO_VERBOSE, "Tentativa de usar objeto inválido " + objeto)
			retorne falso
		}
		retorne verdadeiro
	}

	funcao logico checar_propriedade(inteiro objeto, cadeia propriedade) {
		se (checar_objeto_fraco(objeto)) {
			retorne ob.contem_propriedade(objeto, propriedade)
		}
		retorne falso
	}

	funcao notificar_mudancas() {
		houveramMudancas = verdadeiro
	}

	funcao inserir_objeto(inteiro objeto) {
		adotar(OBJETO_MESTRE, objeto)
		notificar_mudancas()
	}
	
	funcao mudar_objeto_tipo(inteiro objeto, inteiro tipo) {
		se (checar_objeto_fraco(objeto)) {
			ob.atribuir_propriedade(objeto, "tipo", tipo)
		}
	}

	// Para poder fazer queries
	funcao nomear_objeto(inteiro objeto, cadeia nome) {
		se (checar_objeto_fraco(objeto)) {
			ob.atribuir_propriedade(nomeados, nome, objeto)
			ob.atribuir_propriedade(objeto, "nome", nome)
		}
	}

	funcao inteiro procurar_nomeado(cadeia nome) {
		se (ob.contem_propriedade(nomeados, nome)) {
			retorne ob.obter_propriedade_tipo_inteiro(nomeados, nome)
		}
		retorne -1
	}

	funcao inteiro criar_objeto_base(inteiro tipo) {
		inteiro objeto = ob.criar_objeto()
		se (nao checar_objeto_fraco(objeto)) {
			relatar(RELATO_ERRO, "Chegamos no limite de objetos, redirecionando para o objeto 0")
			retorne 0
		}
		ob.atribuir_propriedade(objeto, "x", ATUAL_X)
		ob.atribuir_propriedade(objeto, "modox", ATUAL_POSICIONAMENTO)
		ob.atribuir_propriedade(objeto, "y", ATUAL_Y)
		ob.atribuir_propriedade(objeto, "modoy", ATUAL_POSICIONAMENTO)
		ob.atribuir_propriedade(objeto, "w", ATUAL_W)
		ob.atribuir_propriedade(objeto, "modow", ATUAL_DIMENSIONAMENTO)
		ob.atribuir_propriedade(objeto, "h", ATUAL_H)
		ob.atribuir_propriedade(objeto, "margem_topo", ATUAL_MARGEM_TOPO)
		ob.atribuir_propriedade(objeto, "margem_esquerda", ATUAL_MARGEM_ESQUERDA)
		ob.atribuir_propriedade(objeto, "modoh", ATUAL_DIMENSIONAMENTO)
		ob.atribuir_propriedade(objeto, "cameraX", 0.0)
		ob.atribuir_propriedade(objeto, "cameraY", 0.0)
		ob.atribuir_propriedade(objeto, "visivel", verdadeiro)
		ob.atribuir_propriedade(objeto, "desabilitado", falso)
		ob.atribuir_propriedade(objeto, "focavel", verdadeiro)
		ob.atribuir_propriedade(objeto, "foco", falso)
		ob.atribuir_propriedade(objeto, "tipo", tipo)
		ob.atribuir_propriedade(objeto, "pai", -1)
		ob.atribuir_propriedade(objeto, "opacidade", ATUAL_OPACIDADE)
		ob.atribuir_propriedade(objeto, "rotacao", ATUAL_ROTACAO)
		ob.atribuir_propriedade(objeto, "cor", ATUAL_COR)
		//variaveis do sistema de estilização, não alterar manualmente esses valores pois são calculados
		//automaticamente.
		ob.atribuir_propriedade(objeto, "__x", 0)
		ob.atribuir_propriedade(objeto, "__y", 0)
		ob.atribuir_propriedade(objeto, "__h", 0)
		ob.atribuir_propriedade(objeto, "__w", 0)
		ob.atribuir_propriedade(objeto, "__evento_mouse_esquerdo_pressionado", falso)
		ob.atribuir_propriedade(objeto, "__evento_mouse_direito_pressionado", falso)
		ob.atribuir_propriedade(objeto, "__evento_mouse_meio_pressionado", falso)
		relatar(RELATO_VERBOSE, "Objeto base criado com id " + objeto + " do tipo " + TIPOS[tipo])
		retorne objeto
	}

	funcao inteiro criar_retangulo(real x, real y, real h, real w) {
		inteiro retangulo = criar_objeto_base(TIPOS_RETANGULO)
		ob.atribuir_propriedade(retangulo, "arredondado", ATUAL_ARREDONDADO)
		ob.atribuir_propriedade(retangulo, "preencher", ATUAL_PREENCHER)
		ob.atribuir_propriedade(retangulo, "x", x)
		ob.atribuir_propriedade(retangulo, "y", y)
		ob.atribuir_propriedade(retangulo, "w", w)
		ob.atribuir_propriedade(retangulo, "h", h)
		retorne retangulo
	}

	funcao inteiro criar_caixa_texto(cadeia texto, real x, real y) {
		inteiro objeto = criar_objeto_base(TIPOS_CAIXA_TEXTO)
		ob.atribuir_propriedade(objeto, "x", x)
		ob.atribuir_propriedade(objeto, "y", y)
		ob.atribuir_propriedade(objeto, "texto", texto)
		ob.atribuir_propriedade(objeto, "italico", ATUAL_ITALICO)
		ob.atribuir_propriedade(objeto, "negrito", ATUAL_NEGRITO)
		ob.atribuir_propriedade(objeto, "sublinhado", ATUAL_SUBLINHADO)
		ob.atribuir_propriedade(objeto, "fonte", ATUAL_FONTE)
		ob.atribuir_propriedade(objeto, "tamanho_fonte", ATUAL_TAMANHO_FONTE)
		ob.atribuir_propriedade(objeto, "cor", ATUAL_COR_TEXTO)
		ob.atribuir_propriedade(objeto, "modow", DIMENSIONAMENTO_PX)
		ob.atribuir_propriedade(objeto, "modoh", DIMENSIONAMENTO_PX)
		ob.atribuir_propriedade(objeto, "opacidade", ATUAL_OPACIDADE_TEXTO)
		real tamanho_font = tamanho_fonte // Temporariamente mudamos o tamanho da fonte para poder calcular o tamanho correto
		definir_tamanho_fonte(ATUAL_TAMANHO_FONTE)
		ob.atribuir_propriedade(objeto, "h", tp.inteiro_para_real(gf.altura_texto(texto)))
		ob.atribuir_propriedade(objeto, "w", tp.inteiro_para_real(gf.largura_texto(texto)))
		definir_tamanho_fonte(tamanho_font)
		retorne objeto
	}

	funcao inteiro criar_botao(cadeia texto, cadeia id, real x, real y, real h, real w) {
		inteiro botao = criar_retangulo(x, y, h, w)
		mudar_objeto_tipo(botao, TIPOS_BOTAO)
		inteiro filho_texto = criar_caixa_texto(texto, 0.5, 0.5)
		adotar(botao, filho_texto)
		nomear_objeto(botao, id)
		retorne botao
	}
	
	funcao inteiro criar_objeto_imagem(inteiro imagem, inteiro x, inteiro y) {
		inteiro endereco = ob.criar_objeto()
		ob.atribuir_propriedade(endereco, "imagem", imagem)
		ob.atribuir_propriedade(endereco, "x", x)
		ob.atribuir_propriedade(endereco, "y", y)
		retorne endereco
	}

	funcao inteiro criar_objeto_mestre() {
		inteiro objeto = criar_retangulo(0, 0, janela_altura, janela_largura)
		mudar_objeto_tipo(objeto, TIPOS_MESTRE)
		ob.atribuir_propriedade(objeto, "modow", DIMENSIONAMENTO_PX)
		ob.atribuir_propriedade(objeto, "modoh", DIMENSIONAMENTO_PX)
		OBJETO_MESTRE = objeto
		retorne objeto
	}

	funcao inserir_imagem_buffer(inteiro endereco, inteiro x, inteiro y) {
		inteiro objeto = criar_objeto_imagem(endereco, x, y)
		imagens[quantidade_imagens] = objeto
		quantidade_imagens += 1
	}

	funcao inteiro primeiro_filho_tipo(inteiro objeto, inteiro tipo) {
		se (checar_objeto_fraco(objeto)) {
			para (inteiro i = 0; i < quantidade_filhos[objeto]; i++) {
				inteiro filho = filhos[objeto][i]
				se (checar_objeto_fraco(filho)) {
					inteiro tip = ob.obter_propriedade_tipo_inteiro(filho, "tipo")
					se (tip == tipo) {
						retorne filho
					}
				}
			}
		}
		retorne -1
	}


	funcao renderizar_retangulo(inteiro objeto, inteiro x, inteiro y, inteiro h, inteiro w) {
		logico preencher = ob.obter_propriedade_tipo_logico(objeto, "preencher")
		logico arredondado = ob.obter_propriedade_tipo_logico(objeto, "arredondado")
		gf.desenhar_retangulo(x, y, w, h, arredondado, preencher)
	}

	funcao renderizar_caixa_texto(inteiro objeto, inteiro x, inteiro y, inteiro h, inteiro w) {
		cadeia text = ob.obter_propriedade_tipo_cadeia(objeto, "texto")
		logico italic = ob.obter_propriedade_tipo_logico(objeto, "italico")
		logico negrit = ob.obter_propriedade_tipo_logico(objeto, "negrito")
		logico sublinhad = ob.obter_propriedade_tipo_logico(objeto, "sublinhado")
		cadeia font = ob.obter_propriedade_tipo_cadeia(objeto, "fonte")
		real tamanho_font = ob.obter_propriedade_tipo_real(objeto, "tamanho_fonte")
		definir_estilo(italico, negrit, sublinhad)
		definir_fonte(font)
		definir_tamanho_fonte(tamanho_font)
		gf.desenhar_texto(x, y, text)
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
		inteiro tipo = ob.obter_propriedade_tipo_inteiro(objeto, "tipo")
		inteiro rotaca = ob.obter_propriedade_tipo_inteiro(objeto, "rotacao")
		inteiro co = ob.obter_propriedade_tipo_inteiro(objeto, "cor")
		inteiro opacidad = ob.obter_propriedade_tipo_inteiro(objeto, "opacidade")
		definir_rotacao(rotaca)
		definir_cor(co)
		definir_opacidade(opacidad)
		se (cy != 0 ou cx != 0) {
			renderizar_tipo(tipo, objeto, -cx, -cy, h, w) // x e y têm de levar em consideração o x e y da camera
			inserir_imagem_buffer(gf.renderizar_imagem(canvas_w, canvas_h), xabsoluto, yabsoluto)
		} senao {
			renderizar_tipo(tipo, objeto, xabsoluto, yabsoluto, h, w) // x e y têm de levar em consideração o x e y da camera
		}
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
		inteiro tipo = ob.obter_propriedade_tipo_inteiro(objeto, "tipo")
		real x = ob.obter_propriedade_tipo_real(objeto, "x")
		real y = ob.obter_propriedade_tipo_real(objeto, "y")
		real h = ob.obter_propriedade_tipo_real(objeto, "h")
		real w = ob.obter_propriedade_tipo_real(objeto, "w")		
		logico visivel = ob.obter_propriedade_tipo_logico(objeto, "visivel")
		logico desabilitado = ob.obter_propriedade_tipo_logico(objeto, "desabilitado")
		logico focavel = ob.obter_propriedade_tipo_logico(objeto, "focavel")
		inteiro opacidad = ob.obter_propriedade_tipo_inteiro(objeto, "opacidade")
		inteiro rotaca = ob.obter_propriedade_tipo_inteiro(objeto, "rotacao")
		inteiro co = ob.obter_propriedade_tipo_inteiro(objeto, "cor")
		inteiro __x = ob.obter_propriedade_tipo_inteiro(objeto, "__x")
		inteiro __y = ob.obter_propriedade_tipo_inteiro(objeto, "__y")
		inteiro __h = ob.obter_propriedade_tipo_inteiro(objeto, "__h")
		inteiro __w = ob.obter_propriedade_tipo_inteiro(objeto, "__w")
		string += "\tTipo: " + TIPOS[tipo] + "\n"
		string += "\tID: " + objeto + "\n"
		string += "\tX: " + x + "\n"
		string += "\tY: " + y + "\n"
		string += "\tW: " + w + "\n" 
		string += "\tH: " + h + "\n"
		string += "\tVisivel: " + visivel + "\n"
		string += "\tDesabilitado: " + desabilitado + "\n"
		string += "\tFocavel: " + focavel + "\n"
		string += "\tOpacidade: " + opacidad + "\n"
		string += "\tRotacao: " + rotaca + "\n"
		string += "\tCor: " + co + "\n"
		string += "\tX absoluto: " + __x + "\n"
		string += "\tY absoluto: " + __x + "\n"
		string += "\tH absoluto: " + __h + "\n"
		string += "\tW absoluto: " + __w + "\n"
		string += + "\n}"
		retorne string
	}
	
	funcao logico teste_visibilidade(inteiro objeto) {
		inteiro tipo = ob.obter_propriedade_tipo_inteiro(objeto, "tipo")
		logico visivel = ob.obter_propriedade_tipo_logico(objeto, "visivel")
		inteiro opacidad = ob.obter_propriedade_tipo_inteiro(objeto, "opacidade")
		se (nao visivel ou opacidade <= 0) { // Não renderiza caso o objeto esteja invisível
			relatar(RELATO_DEBUG, "Objeto " + objeto + " está invísivel")
			retorne falso
		}
		retorne verdadeiro
	}

	funcao calcular_propriedades_texto(inteiro objeto) {
		cadeia font = ob.obter_propriedade_tipo_cadeia(objeto, "fonte")
		real tamanho_font = ob.obter_propriedade_tipo_real(objeto, "tamanho_fonte")
		cadeia text = ob.obter_propriedade_tipo_cadeia(objeto, "texto")
		salvar_configuracoes_graficas()
		definir_fonte(font)
		definir_tamanho_fonte(tamanho_font)
		atribuir_h(objeto, gf.altura_texto(text))
		atribuir_w(objeto, gf.largura_texto(text)) // consertar depois... corte de palavras
		restaurar_configuracoes_graficas()	
	}

	funcao calcular_propriedades_tipo(inteiro objeto) {
		se (checar_objeto_fraco(objeto)) {
			inteiro tipo = ob.obter_propriedade_tipo_inteiro(objeto, "tipo")
			escolha (tipo) {
			caso TIPOS_CAIXA_TEXTO:
				calcular_propriedades_texto(objeto)
				pare
			caso contrario:
				pare
			}
		}
	}

	funcao calcular_propriedades(inteiro objeto) {
		calcular_propriedades_tipo(objeto)
		real x = ob.obter_propriedade_tipo_real(objeto, "x")
		real y = ob.obter_propriedade_tipo_real(objeto, "y")
		real h = ob.obter_propriedade_tipo_real(objeto, "h")
		real w = ob.obter_propriedade_tipo_real(objeto, "w")
		inteiro modo_x = ob.obter_propriedade_tipo_inteiro(objeto, "modox")
		inteiro modo_y = ob.obter_propriedade_tipo_inteiro(objeto, "modoy")
		inteiro modo_h = ob.obter_propriedade_tipo_inteiro(objeto, "modoh")
		inteiro modo_w = ob.obter_propriedade_tipo_inteiro(objeto, "modow")
		inteiro pai_x = 0
		inteiro pai_y = 0
		inteiro pai_h = 0
		inteiro pai_w = 0
		inteiro x_calculado = 0
		inteiro y_calculado = 0
		inteiro h_calculado = 0
		inteiro w_calculado = 0
		inteiro margem_t = ob.obter_propriedade_tipo_inteiro(objeto, "margem_topo")
		inteiro margem_e = ob.obter_propriedade_tipo_inteiro(objeto, "margem_esquerda")
		inteiro endereco_pai = receber_pai(objeto)
		relatar(RELATO_VERBOSE, "Endereco pai " + endereco_pai)
		se (checar_objeto_fraco(endereco_pai)) { // 0 indica que não existe um objeto
			pai_x = ob.obter_propriedade_tipo_inteiro(endereco_pai, "__x")
			pai_y = ob.obter_propriedade_tipo_inteiro(endereco_pai, "__y")
			pai_h = ob.obter_propriedade_tipo_inteiro(endereco_pai, "__h")
			pai_w = ob.obter_propriedade_tipo_inteiro(endereco_pai, "__w")
		}
		relatar(RELATO_VERBOSE, "Absoluto pai w " + pai_w)
		x_calculado = pai_x + x
		y_calculado = pai_y + y
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
				relatar(RELATO_VERBOSE, "W calculado " + w_calculado + " clamp " + clamp_real(w, 0 , 1))
				pare
			caso contrario:
				relatar(RELATO_ERRO, "Modo de posicionamento não conhecido " + modo_w)
				pare
		}
		escolha(modo_x) {
			caso POSICIONAMENTO_PX:
				// Por padrão o xabsolut e yabsolut vêm calculado no modo px
				pare
			caso POSICIONAMENTO_RPAI:
				real escalar = clamp_real(x, 0, 1)
				x_calculado = pai_x + (escalar * pai_w) - (w_calculado * escalar)
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
				real escalar = clamp_real(y, 0, 1)
				y_calculado = pai_y + (escalar * pai_h) -  (h_calculado * escalar)
				pare
			caso contrario:
				relatar(RELATO_ERRO, "Modo de posicionamento não conhecido " + modo_y)
				pare
		}
		x_calculado += margem_e
		y_calculado += margem_t
		// Atribuição manual
		relatar(RELATO_VERBOSE, "X calculado " + x_calculado + " Y calculado " + y_calculado + "H calculado " + h_calculado + "W calculado " + w_calculado)
		ob.atribuir_propriedade(objeto, "__x", x_calculado)
		ob.atribuir_propriedade(objeto, "__y", y_calculado)
		ob.atribuir_propriedade(objeto, "__h", h_calculado)
		ob.atribuir_propriedade(objeto, "__w", w_calculado)
		notificar_mudancas()
	}

	// Recalcula posição ou tamanho do objeto a depender de sua relação com o objeto pai
	// Acho que é melhor separar essa função em outras menores, antes que fique complexo de mais....
	funcao pre_renderizar_objeto(inteiro objeto) {
		relatar(RELATO_VERBOSE, "Iniciando renderização de " + objeto_para_string(objeto))
		se (nao teste_visibilidade(objeto)) {
			relatar(RELATO_VERBOSE, "Objeto não foi renderizado pois não está vísivel " + objeto)
			retorne
		}
		calcular_propriedades(objeto)
		inteiro __x = ob.obter_propriedade_tipo_inteiro(objeto, "__x")
		inteiro __y = ob.obter_propriedade_tipo_inteiro(objeto, "__y")
		inteiro __h = ob.obter_propriedade_tipo_inteiro(objeto, "__h")
		inteiro __w = ob.obter_propriedade_tipo_inteiro(objeto, "__w")
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
			pai_x = ob.obter_propriedade_tipo_inteiro(objeto, "__x")
			pai_y = ob.obter_propriedade_tipo_inteiro(objeto, "__y")
			pai_h = ob.obter_propriedade_tipo_inteiro(objeto, "__h")
			pai_w = ob.obter_propriedade_tipo_inteiro(objeto, "__w")
			pai_cx = ob.obter_propriedade_tipo_real(objeto, "cameraX")
			pai_cy = ob.obter_propriedade_tipo_real(objeto, "cameraY")
		}
		inteiro relacao_posicao = colisao_retangulo_retangulo(pai_x, pai_y, pai_h, pai_w, __x, __y, __h, __w)
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
			renderizar_objeto(objeto, __x, __y, pai_cx, pai_cy, __h, __w, canvas_h, canvas_w)
			renderizar_filhos(objeto)
		} senao {
			relatar(RELATO_VERBOSE, "Objeto não renderizou pois está completamente fora de seu container " + objeto)
		}
	}

	funcao renderizar() {
		pre_renderizar()
		pre_renderizar_objeto(OBJETO_MESTRE)
		pos_renderizar()
		renderizar_final()
	}

	funcao renderizar_final() {
		para(inteiro i = 0; i < quantidade_imagens; i ++) {
			inteiro objeto_imagem = imagens[i]
			se (nao (objeto_imagem <= 0)) {
				inteiro imagem = ob.obter_propriedade_tipo_inteiro(objeto_imagem, "imagem")
				inteiro x = ob.obter_propriedade_tipo_inteiro(objeto_imagem, "x")
				inteiro y = ob.obter_propriedade_tipo_inteiro(objeto_imagem, "y")
				relatar(RELATO_VERBOSE, "Desenhando imagem " + imagem + " em x " + x + " em y " + y)
				gf.desenhar_imagem(x, y, imagem)
				gf.liberar_imagem(imagem)
				imagens[i] = 0
			}
		}
		quantidade_imagens = 0
		gf.renderizar()
	}

	funcao pre_renderizar() {
	}

	funcao pos_renderizar() {
	}

	funcao processar_depuracao() {
		se (depuracao e tempo_delta > 0) {
			qps = 1000 / tempo_delta
		}
	}

	funcao focar_objeto(inteiro objeto) {
		se (checar_objeto_fraco(objeto)) {
			logico focavel = ob.obter_propriedade_tipo_logico(objeto, "focavel")
			se (focavel) {
				atribuir_foco(OBJETO_FOCADO, falso)
				OBJETO_FOCADO = objeto
				atribuir_foco(OBJETO_FOCADO, verdadeiro)
			} senao {
				focar_objeto(receber_pai(objeto))
			}
		}
	}

	funcao logico objeto_embaixo_do_mouse(inteiro objeto) {
		se (checar_objeto_fraco(objeto)) {
			inteiro __x = ob.obter_propriedade_tipo_inteiro(objeto, "__x")
			inteiro __y = ob.obter_propriedade_tipo_inteiro(objeto, "__y")
			inteiro __h = ob.obter_propriedade_tipo_inteiro(objeto, "__h")
			inteiro __w = ob.obter_propriedade_tipo_inteiro(objeto, "__w")
			retorne colisao_retangulo_ponto(__x, __y, __h, __w, mouseX, mouseY)
		}
		retorne falso
	}

	funcao inteiro processar_mouse_no_objeto(inteiro objeto) {
		logico m_sobre = objeto_embaixo_do_mouse(objeto)
		logico visivel = ob.obter_propriedade_tipo_logico(objeto, "visivel")
		logico desabilitado = ob.obter_propriedade_tipo_logico(objeto, "desabilitado")
		se (m_sobre e visivel e (nao desabilitado)) {
			inteiro mouse_sobre_filho = -1
			para (inteiro i = 0; i < quantidade_filhos[objeto]; i++) {
				inteiro sobre = processar_mouse_no_objeto(filhos[objeto][i])
				se (sobre != -1) {
					mouse_sobre_filho = sobre
				}
			}
			se (mouse_sobre_filho != -1) {
				retorne mouse_sobre_filho
			}
			retorne objeto
		}
		retorne -1
	}
	
	funcao limpar_eventos() {
		para(inteiro i = 0; i < quantidade_eventos; i++) {
			escreva(i + " " + eventos[i], "\n")
			ob.liberar_objeto(eventos[i])
			eventos[i] = -1
		}
		quantidade_eventos = 0
	}

	funcao inteiro criar_evento_base(inteiro tipo, inteiro objeto) {
		inteiro evento = ob.criar_objeto()
		ob.atribuir_propriedade(evento, "tipo", tipo)
		ob.atribuir_propriedade(evento, "objeto", objeto)
		retorne evento
	}

	funcao criar_evento_mouse(inteiro tipo, inteiro objeto, logico atirar) {
		se (atirar) {
			inteiro evento = criar_evento_base(tipo, objeto)
			relatar(RELATO_DEBUG, "Evento criado com id " + evento)
			eventos[quantidade_eventos] = evento
			quantidade_eventos += 1
		}
	}

	funcao processar_mouse() {
		mouseX_antes = mouseX
		mouseY_antes = mouseY
		mouse_pressionado_antes[MOUSE_ESQUERDO] = mouse_pressionado[MOUSE_ESQUERDO]
		mouse_pressionado_antes[MOUSE_MEIO] = mouse_pressionado[MOUSE_MEIO]
		mouse_pressionado_antes[MOUSE_DIREITO] = mouse_pressionado[MOUSE_DIREITO]
		mouse_sobre_antes = mouse_sobre
		mouseX = mu.posicao_x()
		mouseY = mu.posicao_y()
		mouse_pressionado[MOUSE_ESQUERDO] = mu.botao_pressionado(mu.BOTAO_ESQUERDO)
		mouse_pressionado[MOUSE_MEIO] = mu.botao_pressionado(mu.BOTAO_MEIO)
		mouse_pressionado[MOUSE_DIREITO] = mu.botao_pressionado(mu.BOTAO_DIREITO)
		mouse_sobre = processar_mouse_no_objeto(OBJETO_MESTRE)
		inteiro deltaX = mouseX - mouseX_antes
		inteiro deltaY = mouseY - mouseY_antes
		logico pressionado_esquerdo = mouse_pressionado[MOUSE_ESQUERDO]
		logico pressionado_meio = mouse_pressionado[MOUSE_MEIO]
		logico pressionado_direito = mouse_pressionado[MOUSE_DIREITO]
		logico solto_esquerdo = mouse_pressionado_antes[MOUSE_ESQUERDO] e nao mouse_pressionado[MOUSE_ESQUERDO]
		logico solto_meio = mouse_pressionado_antes[MOUSE_MEIO] e nao mouse_pressionado[MOUSE_MEIO]
		logico solto_direito = mouse_pressionado_antes[MOUSE_DIREITO] e nao mouse_pressionado[MOUSE_DIREITO]
		se (mouse_pressionado_antes[MOUSE_ESQUERDO] e solto_esquerdo) {
			focar_objeto(mouse_sobre)
		}
		inteiro pai = mouse_sobre
		enquanto (checar_objeto_fraco(pai)) {
			logico pressionado_esquerdo_antes_objeto = ob.obter_propriedade_tipo_logico(pai, "__evento_mouse_esquerdo_pressionado")
			logico pressionado_meio_antes_objeto = ob.obter_propriedade_tipo_logico(pai, "__evento_mouse_meio_pressionado")
			logico pressionado_direito_antes_objeto = ob.obter_propriedade_tipo_logico(pai, "__evento_mouse_direito_pressionado")
			criar_evento_mouse(EVENTO_MOUSE_ESQUERDO_CLICAR, pai, pressionado_esquerdo_antes_objeto e solto_esquerdo)
			criar_evento_mouse(EVENTO_MOUSE_MEIO_CLICAR, pai, pressionado_meio_antes_objeto e solto_meio)
			criar_evento_mouse(EVENTO_MOUSE_DIREITO_CLICAR, pai, pressionado_direito_antes_objeto e solto_direito)
			criar_evento_mouse(EVENTO_MOUSE_ESQUERDO_PRESSIONAR, pai, pressionado_esquerdo)
			criar_evento_mouse(EVENTO_MOUSE_MEIO_PRESSIONAR, pai, pressionado_meio)
			criar_evento_mouse(EVENTO_MOUSE_DIREITO_PRESSIONAR, pai, pressionado_direito)
			criar_evento_mouse(EVENTO_MOUSE_ESQUERDO_SOLTAR, pai, solto_esquerdo)
			criar_evento_mouse(EVENTO_MOUSE_MEIO_SOLTAR, pai, solto_meio)
			criar_evento_mouse(EVENTO_MOUSE_DIREITO_SOLTAR, pai, solto_direito)
			ob.atribuir_propriedade(pai,"__evento_mouse_esquerdo_pressionado", pressionado_esquerdo)
			ob.atribuir_propriedade(pai,"__evento_mouse_meio_pressionado", pressionado_meio)
			ob.atribuir_propriedade(pai,"__evento_mouse_direito_pressionado", pressionado_direito)
			pai = receber_pai(pai)
		}
	}

	funcao processar_teclado() {
		
	}

	funcao processar_tela() {
		inteiro h = gf.altura_janela()
		inteiro w = gf.largura_janela()
		se (h != janela_altura ou w != janela_largura) {
			janela_altura = h
			janela_largura = w
			atribuir_h(OBJETO_MESTRE, h)
			atribuir_w(OBJETO_MESTRE, w)
		}
	}

	funcao processar_inicial() {
		inteiro agora = ut.tempo_decorrido()
		tempo_delta = agora - tempo_antes
		tempo_antes = agora
		limpar_eventos()
	}

	funcao processar_final() {
		inteiro agora = ut.tempo_decorrido()
		tempo_frame = agora - tempo_antes
		inteiro tempo_limite = segundos(1)/qps_maximo
		inteiro tempo_restante = tempo_limite - tempo_frame
		se (qps_limite > 0 e qps_limite != 0) {
			tempo_limite = segundos(1)/qps_limite
			tempo_restante = tempo_limite - tempo_frame
		}
		se (tempo_restante > 0) {
			ut.aguarde(tempo_restante)
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
	
	funcao real porcentagem_limite(real valor, real limite) {
		se (valor < 0 ou limite <= 0) {
			retorne 0.0
		}
		se (valor >= 0 e valor <= 1) {
			retorne valor
		} senao se (valor > 1 e valor <= limite) {
			retorne valor/limite
		}
		retorne 1.0
	}

	funcao inteiro porcentagem_limite_inteiro(real valor, inteiro limite) {
		se (valor < 0 ou limite <= 0) {
			retorne 0
		}
		se (valor >= 0 e valor <= 1) {
			retorne (valor * limite)
		} senao se (valor > 1 e valor <= limite) {
			retorne valor
		}
		retorne limite
	}
	
	
	// Usar sempre essas funções quando for manipular objetos
	funcao atribuir_propriedade_inteiro(inteiro objeto, cadeia p, inteiro i) {
		se (nao checar_propriedade(objeto, p)) {
			retorne
		}
		ob.atribuir_propriedade(objeto, p, i)
		notificar_mudancas()
	}
	funcao atribuir_propriedade_real(inteiro objeto, cadeia p, real r) {
		se (nao checar_propriedade(objeto, p)) {
			retorne
		}
		ob.atribuir_propriedade(objeto, p, r)
		notificar_mudancas()
	}
	funcao atribuir_propriedade_cadeia(inteiro objeto, cadeia p, cadeia c) {
		se (nao checar_propriedade(objeto, p)) {
			retorne
		}
		ob.atribuir_propriedade(objeto, p, c)
		notificar_mudancas()
	}
	funcao atribuir_propriedade_caracter(inteiro objeto,cadeia p,  caracter c) {
		se (nao checar_propriedade(objeto, p)) {
			retorne
		}
		ob.atribuir_propriedade(objeto, p, c)
		notificar_mudancas()
	}
	funcao atribuir_propriedade_logico(inteiro objeto, cadeia p, logico l) {
		se (nao checar_propriedade(objeto, p)) {
			retorne
		}
		ob.atribuir_propriedade(objeto, p, l)
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

	funcao atribuir_opacidade(inteiro objeto, real o) {
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
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_cadeia(objeto, "texto", t)
		}
	}

	funcao atribuir_fonte(inteiro objeto, cadeia f) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_cadeia(objeto, "fonte", f)
		}
	}

	funcao atribuir_tamanho_fonte(inteiro objeto, real tf) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_real(objeto, "tamanho_fonte", tf)
		}
	}

	funcao atribuir_italico(inteiro objeto, logico i) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_logico(objeto, "italico", i)
		}
	}

	funcao atribuir_negrito(inteiro objeto, logico n) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_logico(objeto, "negrito", n)
		}
	}

	funcao atribuir_sublinhado(inteiro objeto, logico s) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_logico(objeto, "sublinhado", s)
		}
	}

	funcao atribuir_preencher(inteiro objeto, logico p) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_logico(objeto, "preencher", p)
		}
	}

	funcao atribuir_arredondado(inteiro objeto, logico a) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_logico(objeto, "arredondado", a)
		}
	}

	funcao atribuir_margem_topo(inteiro objeto, inteiro m) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_inteiro(objeto, "margem_topo", m)
		}
	}

	funcao atribuir_margem_esquerda(inteiro objeto, inteiro m) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_inteiro(objeto, "margem_esquerda", m)
		}
	}

	funcao atribuir_desabilitado(inteiro objeto, logico d) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_logico(objeto, "desabilitado", d)
		}
	}

	funcao atribuir_focavel(inteiro objeto, logico f) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_logico(objeto, "focavel", f)
		}
	}

	funcao inicializar_graficos() {
		gf.iniciar_modo_grafico(falso)
		janela_largura = gf.largura_tela()
		janela_altura = gf.altura_tela()
		gf.definir_dimensoes_janela(janela_largura, janela_altura)
		gf.definir_titulo_janela("Gráficos")
	}

	funcao inicializar_objetos() {
		criar_objeto_mestre() // nenhum objeto pode ter ID = 0, então nos livramos dele no ínicio.
	}

	funcao biblioteca_ui_finalizar() {
		gf.encerrar_modo_grafico()
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

	funcao inteiro construir_caixa_com_label(cadeia label, real x, real y, real h, real w) {
		inteiro caixa = criar_retangulo(x, y, h, w)
			inteiro labe = criar_caixa_texto(label, 0, 0)
			atribuir_margem_esquerda(labe, 10)
			atribuir_margem_topo(labe, 10)
			adotar(caixa, labe)
		retorne caixa
	}


	funcao inteiro construir_cadastro_aluno() {
		inteiro cadastro_aluno = construir_caixa_com_label("Cadastrar aluno", 0.5, 0.5, 0.35, 0.35)
		atribuir_cor(cadastro_aluno, COR_BACKGROUND_LIGHT_GRAY)
			inteiro adicionar_aluno = criar_botao("Adicionar", "adicionar_aluno", 0.5, 0.9, 0.1, 0.15)
			atribuir_arredondado(adicionar_aluno, verdadeiro)
			atribuir_focavel(adicionar_aluno, falso)
			atribuir_cor(adicionar_aluno, COR_PRIMARY)
				inteiro adicionar_aluno_texto = primeiro_filho_tipo(adicionar_aluno, TIPOS_CAIXA_TEXTO)
				atribuir_opacidade(adicionar_aluno_texto, porcentagem_limite_inteiro(0.8, 255))
				atribuir_tamanho_fonte(adicionar_aluno_texto, 16)
				adotar(cadastro_aluno, adicionar_aluno)
		retorne cadastro_aluno
	}

	// A PARTIR DAQUI NÃO É MAIS CÓDIGO DA BIBLIOTECA
	funcao inteiro construir_tela_principal() {
		inteiro tela = criar_retangulo(0, 0, 1, 1)
		atribuir_cor(tela, COR_BACKGROUND_GRAY)
			inteiro header = criar_retangulo(0, 0, 50, 1)
			atribuir_modoh(header, DIMENSIONAMENTO_PX)
			atribuir_cor(header, COR_BACKGROUND_LIGHT_GRAY)
			adotar(tela, header)
				inteiro botao_menu = criar_retangulo(0, 0.5, 40, 40)
				nomear_objeto(botao_menu, "botao_sidemenu")
				atribuir_modow(botao_menu, DIMENSIONAMENTO_PX)
				atribuir_modoh(botao_menu, DIMENSIONAMENTO_PX)
				atribuir_margem_esquerda(botao_menu, 10)
				atribuir_cor(botao_menu, COR_SECONDARY)
				atribuir_arredondado(botao_menu, verdadeiro)
				adotar(header, botao_menu)
					inteiro barras_holder = criar_retangulo(0.5, 0.5, 0.6, 0.8)
					atribuir_cor(barras_holder, COR_SECONDARY)
					adotar(botao_menu, barras_holder)
						inteiro barra_1 = criar_retangulo(0, 0, 0.18, 1)
						adotar(barras_holder, barra_1)
						inteiro barra_2 = criar_retangulo(0, 0.5, 0.18, 1)
						adotar(barras_holder, barra_2)
						inteiro barra_3 = criar_retangulo(0, 1, 0.18, 1)
						adotar(barras_holder, barra_3)
				inteiro texto = criar_caixa_texto("Cadastro de alunos", 0.5, 0.5)
				atribuir_cor(texto, gf.COR_PRETO)
				atribuir_tamanho_fonte(texto, 30)
				adotar(header, texto)
				inteiro cadastro_aluno = construir_cadastro_aluno()
				adotar(tela, cadastro_aluno)
		retorne tela
	}
	
	funcao inicio()
 	{
 		inicializar_biblioteca_ui()
		definir_fonte("Roboto")
		inteiro fps = criar_caixa_texto("FPS: 0", 1, 0)
		atribuir_cor(fps, gf.COR_PRETO)
		inserir_objeto(construir_tela_principal())
		inserir_objeto(fps)
		inteiro periodo = 0
		enquanto (nao kb.tecla_pressionada(kb.TECLA_ESC))
		{	
			//periodo += tempo_delta
			//se (periodo >= segundos(1)) {
			//	periodo = 0
			//	definir_janela_dimensoes(ut.sorteia(400, 1920), ut.sorteia(300, 1080))
			//}
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
 * @POSICAO-CURSOR = 33732; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */