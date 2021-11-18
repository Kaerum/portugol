programa
{
	inclua biblioteca Graficos --> gf
	inclua biblioteca Teclado --> kb
	inclua biblioteca Matematica --> mt
	inclua biblioteca Tipos --> tp
	inclua biblioteca Util --> ut
	inclua biblioteca Mouse --> mu
	inclua biblioteca Objetos --> ob
	inclua biblioteca Texto --> tx
	inclua biblioteca Arquivos --> ar

	//CORES
	const inteiro COR_BACKGROUND_LIGHT_GRAY = 0xeef0f1
	const inteiro COR_BACKGROUND_GRAY = 0xe0e0e0
	const inteiro COR_TEXTO_BOTAO = 0x3b3b3b
	const inteiro COR_PROFUNDO = 0xb3b3b3
	const inteiro COR_PRIMARY = -1610948
	const inteiro COR_PRIMARY_LIGHT = -25751
	const inteiro COR_PRIMARY_DARK = -5293040
	const inteiro COR_SECONDARY = -12868914
	const inteiro COR_PRETO = 0
	const inteiro COR_PERIGO = 0xd62e00

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
	inteiro OBJETO_FOCADO = -1
	const inteiro MAXIMO_DE_PAIS = 3000
	const inteiro MAXIMO_DE_FILHOS = 200

	inteiro quantidade_filhos[MAXIMO_DE_PAIS]
	inteiro filhos[MAXIMO_DE_PAIS][MAXIMO_DE_FILHOS]
	inteiro nomeados = criar_objeto()

	// Buffer de imagens, elas têm de ser desenhadas no final!
	inteiro quantidade_imagens = 0
	inteiro imagens[MAXIMO_DE_ELEMENTOS]
	//inteiro objetos_imagens[JANELA_LARGURA_MAXIMA * JANELA_ALTURA_MAXIMA]

	// Tipos de componentes da interface
	const inteiro TIPOS_MESTRE = 0
	const inteiro TIPOS_RETANGULO = 1
	const inteiro TIPOS_CAIXA_TEXTO = 2
	const inteiro TIPOS_BOTAO = 3
	const inteiro TIPOS_CAIXA_TEXTO_EDITAVEL = 4

	const cadeia TIPOS[] = {"MESTRE", "RETANGULO", "CAIXA_TEXTO", "BOTAO", "CAIXA_TEXTO_EDITAVEL"}
	
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
	// Teclado
	
	

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
	const inteiro EVENTO_TECLA_PRESSIONAR = 10
	const inteiro LIMITE_EVENTOS = 4096
	const inteiro LIMITE_ARGUMENTOS = 10
	inteiro quantidade_eventos = 0
	/*
		Limpa-se todos os x nos eventos no ínicio de cada tick
	*/
	inteiro eventos [LIMITE_EVENTOS]
	

	// Padrões de estilização
	const inteiro PADROES_RAIO_X = 0
	const inteiro PADROES_RAIO_Y = 0
	const logico PADROES_PREENCHER = verdadeiro
	const inteiro PADROES_OPACIDADE = 255
	const inteiro PADROES_ROTACAO = 0
	const inteiro PADROES_COR = -1
	const inteiro PADROES_COR_TEXTO = 0
	const inteiro PADROES_COR_PROFUNDIDADE = 0xb3b3b3
	const inteiro PADROES_OPACIDADE_TEXTO = 255
	const inteiro PADROES_OPACIDADE_PLACEHOLDER = 150
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
	inteiro ATUAL_RAIO_X = PADROES_RAIO_X
	inteiro ATUAL_RAIO_Y = PADROES_RAIO_Y
	logico ATUAL_PREENCHER = PADROES_PREENCHER
	inteiro ATUAL_OPACIDADE = PADROES_OPACIDADE
	inteiro ATUAL_ROTACAO = PADROES_ROTACAO
	inteiro ATUAL_COR = PADROES_COR
	inteiro ATUAL_COR_TEXTO = PADROES_COR_TEXTO
	inteiro ATUAL_COR_PROFUNDIDADE = PADROES_COR_PROFUNDIDADE
	inteiro ATUAL_OPACIDADE_TEXTO = PADROES_OPACIDADE_TEXTO
	inteiro ATUAL_OPACIDADE_PLACEHOLDER = PADROES_OPACIDADE_PLACEHOLDER
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

	funcao destruir_filhos(inteiro pai) {
		se (checar_objeto_fraco(pai)) {
			para (inteiro i = 0; i < quantidade_filhos[pai]; i++) {
				inteiro filho = filhos[pai][i]
				ob.liberar_objeto(filho)
				filhos[pai][i] = -1
			}
			quantidade_filhos[pai] = 0
		}
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

	funcao cadeia receber_nome(inteiro objeto) {
		se (checar_objeto_fraco(objeto)) {
			se (ob.contem_propriedade(objeto, "nome")) {
				retorne ob.obter_propriedade_tipo_cadeia(objeto, "nome")
			}
		}
		retorne "__nonexistantobject0x190231"
	}

	funcao inteiro procurar_nomeado(cadeia nome) {
		se (ob.contem_propriedade(nomeados, nome)) {
			retorne ob.obter_propriedade_tipo_inteiro(nomeados, nome)
		}
		retorne -1
	}

	funcao inteiro criar_objeto() {
		retorne ob.criar_objeto()
	}

	funcao inteiro criar_objeto_base(inteiro tipo) {
		inteiro objeto = criar_objeto()
		se (nao checar_objeto_fraco(objeto)) {
			relatar(RELATO_ERRO, "Chegamos no limite de objetos, redirecionando para o objeto 0")
			retorne OBJETO_MESTRE
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
		ob.atribuir_propriedade(retangulo, "raio_x", ATUAL_RAIO_X)
		ob.atribuir_propriedade(retangulo, "raio_y", ATUAL_RAIO_Y)
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

	funcao inteiro criar_caixa_texto_editavel(cadeia texto, real x, real y, real h, real w) {
		inteiro container = criar_retangulo(x, y, h, w)
		ob.atribuir_propriedade(container, "cor", ATUAL_COR_PROFUNDIDADE)
		mudar_objeto_tipo(container, TIPOS_CAIXA_TEXTO_EDITAVEL)
		ob.atribuir_propriedade(container, "valor", "")
		ob.atribuir_propriedade(container, "placeholder", texto)
		inteiro objeto = criar_caixa_texto(texto, 0.5, 0.5)
		ob.atribuir_propriedade(objeto, "opacidade", ATUAL_OPACIDADE_PLACEHOLDER)
		ob.atribuir_propriedade(objeto, "focavel", falso)
		adotar(container, objeto)
		retorne container
	}

	funcao inteiro criar_botao(cadeia texto, cadeia id, real x, real y, real h, real w) {
		inteiro botao = criar_retangulo(x, y, h, w)
		mudar_objeto_tipo(botao, TIPOS_BOTAO)
		inteiro filho_texto = criar_caixa_texto(texto, 0.5, 0.5)
		ob.atribuir_propriedade(filho_texto, "cor", COR_TEXTO_BOTAO)
		adotar(botao, filho_texto)
		nomear_objeto(botao, id)
		retorne botao
	}
	
	funcao inteiro criar_objeto_imagem(inteiro imagem, inteiro x, inteiro y) {
		inteiro endereco = criar_objeto()
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
		inteiro raio_x = ob.obter_propriedade_tipo_inteiro(objeto, "raio_x")
		inteiro raio_y = ob.obter_propriedade_tipo_inteiro(objeto, "raio_y")
		gf.desenhar_retangulo_arredondado(x, y, w, h, raio_x, raio_y, preencher)
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

	funcao renderizar_caixa_texto_editavel(inteiro objeto, inteiro x, inteiro y, inteiro h, inteiro w) {
		cadeia placeholder = ob.obter_propriedade_tipo_cadeia(objeto, "placeholder")
		cadeia valor = ob.obter_propriedade_tipo_cadeia(objeto, "valor")
		inteiro texto_filho = primeiro_filho_tipo(objeto, TIPOS_CAIXA_TEXTO)
		se (valor != "") {
			atribuir_texto(texto_filho, valor)
		} senao {
			atribuir_texto(texto_filho, placeholder)
		}
		renderizar_retangulo(objeto, x, y, h, w)
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
		caso TIPOS_CAIXA_TEXTO_EDITAVEL:
			renderizar_caixa_texto_editavel(objeto, x, y, h, w)
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
			ob.liberar_objeto(eventos[i])
			eventos[i] = -1
		}
		quantidade_eventos = 0
	}

	funcao adicionar_evento(inteiro evento) {
		eventos[quantidade_eventos] = evento
		quantidade_eventos += 1
	}

	funcao criar_evento_teclado(inteiro tipo, inteiro tecla) {
		se (checar_objeto_fraco(OBJETO_FOCADO)) {
			inteiro evento = criar_evento_base(tipo, OBJETO_FOCADO)
			ob.atribuir_propriedade(evento, "tecla", tecla)
			adicionar_evento(evento)
		}
	}

	funcao inteiro criar_evento_base(inteiro tipo, inteiro objeto) {
		inteiro evento = criar_objeto()
		ob.atribuir_propriedade(evento, "tipo", tipo)
		ob.atribuir_propriedade(evento, "objeto", objeto)
		retorne evento
	}

	funcao criar_evento_mouse(inteiro tipo, inteiro objeto, logico atirar) {
		se (checar_objeto_fraco(objeto) e atirar) {
			inteiro evento = criar_evento_base(tipo, objeto)
			adicionar_evento(evento)
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
		se (kb.alguma_tecla_pressionada()) {
			inteiro tecla = kb.ler_tecla()
			criar_evento_teclado(EVENTO_TECLA_PRESSIONAR, tecla)
		}
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

	funcao processar_focado() {}

	funcao processar_generico() {}

	funcao processar_eventos() {
		para (inteiro i = 0; i < quantidade_eventos; i++) {
			inteiro evento = eventos[i]
			inteiro objeto = ob.obter_propriedade_tipo_inteiro(evento, "objeto")
			se (checar_objeto_fraco(objeto)) {
				inteiro tipo = ob.obter_propriedade_tipo_inteiro(evento, "tipo")
				logico aceita_entrada = ob.contem_propriedade(objeto, "valor")
				escolha (tipo) {
				caso EVENTO_TECLA_PRESSIONAR:
					se (aceita_entrada) {
						inteiro tecla = ob.obter_propriedade_tipo_inteiro(evento, "tecla")
						cadeia valor = ob.obter_propriedade_tipo_cadeia(objeto, "valor")
						inteiro tamanho_valor = tx.numero_caracteres(valor)
						escolha (tecla) {
						caso kb.TECLA_BACKSPACE:
							inteiro diminuir = tamanho_valor - 1
							se (diminuir < 0) {
								diminuir = 0
							}
							valor = tx.extrair_subtexto(valor, 0, diminuir)
							pare
						caso kb.TECLA_ESPACO:
							valor += ' '
							pare
						caso contrario:
							caracter char = kb.caracter_tecla(tecla)
							valor += char
							pare
						}
						atribuir_valor(objeto, valor)
					}
					pare
				caso contrario:
					pare
				}
			}
		}
	}

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

	funcao atribuir_raio_x(inteiro objeto, inteiro r) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_inteiro(objeto, "raio_x", r)
		}
	}

	funcao atribuir_raio_y(inteiro objeto, inteiro r) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_inteiro(objeto, "raio_y", r)
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

	funcao atribuir_valor(inteiro objeto, cadeia v) {
		se (checar_objeto_fraco(objeto)) {
			atribuir_propriedade_cadeia(objeto, "valor", v)
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
		processar_eventos()
		processar_final()
	}

	// A PARTIR DAQUI NÃO É MAIS CÓDIGO DA BIBLIOTECA

	const cadeia ARQUIVO = "./alunos.txt"

	const inteiro ALTURA_CONTAINER_ALUNO = 40

	const inteiro limite_alunos = 1024
	inteiro quantidade_alunos = 0
	inteiro alunos[limite_alunos]

	// Nomes de objetos
	// Containers
	const cadeia CONTAINER_LISTAGEM_ALUNOS = "container_listagem_alunos"
	// ESTADO
	const cadeia ESTADO_LISTAGEM_ALUNOS = "estado_listagem_alunos"
	// Telas
	const cadeia TELA_CADASTRO_ALUNOS = "tela_cadastro_alunos"
	const cadeia TELA_LISTAGEM_ALUNOS = "tela_listagem_alunos"
	// Botões
	const cadeia BOTAO_ADICIONAR_ALUNO = "botao_adicionar_aluno"
	const cadeia BOTAO_CADASTRO_ALUNOS = "botao_cadastro_alunos"
	const cadeia BOTAO_LISTAGEM_ALUNOS = "botao_listagem_alunos"
	const cadeia BOTAO_SISTEMA_SAIR = "botao_sistema_sair"
	const cadeia BOTAO_LISTAGEM_PASSAR_PAGINA = "botao_listagem_passar_pagina"
	const cadeia BOTAO_LISTAGEM_VOLTAR_PAGINA = "botao_listagem_voltar_pagina"
	// Caixas editáveis
	const cadeia CAIXA_NOME_ALUNO = "caixa_nome_aluno"
	const cadeia CAIXA_IDADE_ALUNO = "caixa_idade_aluno"
	const cadeia CAIXA_TELEFONE_ALUNO = "caixa_telefone_aluno"

	funcao recarregar_listagem() {
		inteiro container_alunos = procurar_nomeado(CONTAINER_LISTAGEM_ALUNOS)
		inteiro botao_anterior = procurar_nomeado(BOTAO_LISTAGEM_VOLTAR_PAGINA)
		inteiro botao_proximo = procurar_nomeado(BOTAO_LISTAGEM_PASSAR_PAGINA)
		inteiro estado = procurar_nomeado(ESTADO_LISTAGEM_ALUNOS)
		destruir_filhos(container_alunos)
		inteiro pagina = ob.obter_propriedade_tipo_inteiro(estado, "pagina")
		inteiro maximo_alunos = ob.obter_propriedade_tipo_inteiro(estado, "alunos_por_pagina")
		inteiro index_inicio = maximo_alunos * (pagina - 1)
		inteiro ultima_pagina = mt.arredondar(( quantidade_alunos / maximo_alunos ) - 0.5, 1)
		se (index_inicio < 0) {
			index_inicio = 0
		}
		atribuir_visivel(botao_anterior, verdadeiro)
		atribuir_visivel(botao_proximo, verdadeiro)
		se (pagina == 0) {
			atribuir_visivel(botao_anterior, falso)
		}
		se (pagina == ultima_pagina) {
			atribuir_visivel(botao_proximo, falso)
		}
		se (quantidade_alunos > 0) {
			para (inteiro i = 0; i < quantidade_alunos e i < (index_inicio + maximo_alunos - 1); i++) {
			inteiro aluno = alunos[i]
			cadeia nome = ob.obter_propriedade_tipo_cadeia(aluno, "nome")
			inteiro idade = ob.obter_propriedade_tipo_inteiro(aluno, "idade")
			cadeia telefone = ob.obter_propriedade_tipo_cadeia(aluno, "telefone")
				inteiro objeto_aluno = construir_aluno_listagem(nome, idade, telefone, i)
				adotar(container_alunos, objeto_aluno)
			}
		} senao {
			inteiro aviso = criar_caixa_texto("Não existem alunos cadastrados no sistema", 0.5, 0.5)
			adotar(container_alunos, aviso)
		}
	}

	funcao carregar_alunos() {
		se (ar.arquivo_existe(ARQUIVO)) {
			inteiro handle = ar.abrir_arquivo(ARQUIVO, ar.MODO_LEITURA)
			cadeia linha = ""
			inteiro controle = 0
			cadeia nome = ""
			cadeia idade = ""
			cadeia telefone = ""
			enquanto (linha != "__fim__") {
				relatar(RELATO_DEBUG, linha + " controle " + controle)
				linha = ar.ler_linha(handle)
				escolha (controle) {
					caso 0:
						nome = linha
						pare
					caso 1:
						idade = linha
						pare
					caso 2:
						telefone = linha
						pare
					caso 3:
						adicionar_aluno(nome, idade, telefone)
						nome = ""
						idade = ""
						telefone = ""
						controle = -1
						pare
					caso contrario:
						controle = -1
						pare
				}
				controle++
			}
		   ar.fechar_arquivo(handle)
		}
	}

	funcao salvar_alunos() {
		inteiro handle = ar.abrir_arquivo(ARQUIVO, ar.MODO_ESCRITA)
		para (inteiro i = 0; i < quantidade_alunos; i++) {
			inteiro aluno = alunos[i]
			cadeia nome = ob.obter_propriedade_tipo_cadeia(aluno, "nome")
			inteiro idade = ob.obter_propriedade_tipo_inteiro(aluno, "idade")
			cadeia telefone = ob.obter_propriedade_tipo_cadeia(aluno, "telefone")
			cadeia idad = tp.inteiro_para_cadeia(idade, 10)
			ar.escrever_linha(nome, handle)
			ar.escrever_linha(idad, handle)
			ar.escrever_linha(telefone, handle)
			ar.escrever_linha("__continuar__", handle)
		}
		ar.escrever_linha("__fim__", handle)
		ar.fechar_arquivo(handle)
	}

	funcao logico adicionar_aluno(cadeia nome, cadeia idade, cadeia telefone) {
		se (tp.cadeia_e_inteiro(idade, 10) e nome != "" e telefone != "") {
			inteiro idad = tp.cadeia_para_inteiro(idade, 10)
			inteiro aluno = criar_objeto()
			ob.atribuir_propriedade(aluno, "nome", nome)
			ob.atribuir_propriedade(aluno, "idade", idad)
			ob.atribuir_propriedade(aluno, "telefone", telefone)
			alunos[quantidade_alunos] = aluno
			quantidade_alunos++
			retorne verdadeiro
		} senao {
			retorne falso
		}

	}

	funcao botao_adicionar_aluno() {
		inteiro caixa_nome = procurar_nomeado(CAIXA_NOME_ALUNO)
		inteiro caixa_idade = procurar_nomeado(CAIXA_IDADE_ALUNO)
		inteiro caixa_telefone = procurar_nomeado(CAIXA_TELEFONE_ALUNO)
		se (caixa_nome == -1 ou caixa_idade == -1 ou caixa_telefone == -1) {
			relatar(RELATO_ERRO, "Não foi possível encontrar as caixas de texto necessárias para adc aluno")
		} senao {
			cadeia nome = ob.obter_propriedade_tipo_cadeia(caixa_nome, "valor")
			cadeia idade = ob.obter_propriedade_tipo_cadeia(caixa_idade, "valor")
			cadeia telefone = ob.obter_propriedade_tipo_cadeia(caixa_telefone, "valor")
			se (adicionar_aluno(nome, idade, telefone)) {
				atribuir_valor(caixa_nome, "")
				atribuir_valor(caixa_idade, "")
				atribuir_valor(caixa_telefone, "")
			}
		}
	}

	funcao botao_sistema_sair() {
		salvar_alunos()
		biblioteca_ui_finalizar()
	}

	funcao botao_cadastro_alunos() {
		inteiro listagem = procurar_nomeado(TELA_LISTAGEM_ALUNOS)
		inteiro cadastro = procurar_nomeado(TELA_CADASTRO_ALUNOS)
		atribuir_visivel(listagem, falso)
		atribuir_visivel(cadastro, verdadeiro)
	}

	funcao botao_listagem_alunos() {
		inteiro listagem = procurar_nomeado(TELA_LISTAGEM_ALUNOS)
		inteiro cadastro = procurar_nomeado(TELA_CADASTRO_ALUNOS)
		atribuir_visivel(listagem, verdadeiro)
		atribuir_visivel(cadastro, falso)
		recarregar_listagem()
	}

	funcao botao_listagem_proximo() {
		inteiro estado = procurar_nomeado(ESTADO_LISTAGEM_ALUNOS)
	}

	funcao botao_listagem_anterior() {
		inteiro estado = procurar_nomeado(ESTADO_LISTAGEM_ALUNOS)
	}
	
	funcao inteiro construir_caixa_com_label(cadeia label, real x, real y, real h, real w) {
		inteiro caixa = criar_retangulo(x, y, h, w)
			inteiro labe = criar_caixa_texto(label, 0, 0)
			atribuir_opacidade(labe, porcentagem_limite_inteiro(0.522, 255))
			atribuir_tamanho_fonte(labe, 24)
			atribuir_margem_esquerda(labe, 10)
			atribuir_margem_topo(labe, 10)
			adotar(caixa, labe)
		retorne caixa
	}

	funcao inteiro construir_aluno_listagem(cadeia nome, inteiro idade, cadeia telefone, inteiro index) {
		cadeia idad = "??"
		idad = tp.inteiro_para_cadeia(idade, 10)
		inteiro container = criar_retangulo(0, index * ALTURA_CONTAINER_ALUNO, ALTURA_CONTAINER_ALUNO, 1)
		atribuir_modoy(container, POSICIONAMENTO_PX)
			inteiro texto_nome = criar_caixa_texto(nome, 0, 0)
			adotar(container, texto_nome)
			inteiro texto_idade = criar_caixa_texto(idad, 0.33, 0)
			adotar(container, texto_idade)
			inteiro texto_telefone = criar_caixa_texto(telefone, 0.66, 0)
			adotar(container, texto_telefone)
		retorne container
	}

	funcao inteiro construir_cadastro_aluno() {
		inteiro cadastro_aluno = construir_caixa_com_label("Cadastrar aluno", 0.5, 0.5, 0.35, 0.35)
		nomear_objeto(cadastro_aluno, TELA_CADASTRO_ALUNOS)
		atribuir_raio_x(cadastro_aluno, 4)
		atribuir_raio_y(cadastro_aluno, 4)
		atribuir_cor(cadastro_aluno, gf.COR_BRANCO)
			inteiro adicionar_aluno = criar_botao("Adicionar", BOTAO_ADICIONAR_ALUNO, 0.5, 0.9, 0.1, 0.15)
			atribuir_raio_x(adicionar_aluno, 10)
			atribuir_raio_y(adicionar_aluno, 10)
			atribuir_focavel(adicionar_aluno, falso)
			atribuir_cor(adicionar_aluno, COR_PRIMARY)
			adotar(cadastro_aluno, adicionar_aluno)
				inteiro adicionar_aluno_texto = primeiro_filho_tipo(adicionar_aluno, TIPOS_CAIXA_TEXTO)
				atribuir_tamanho_fonte(adicionar_aluno_texto, 16)
			inteiro nome_do_aluno = criar_caixa_texto_editavel("Insira o nome do aluno", 0.5, 0.2, 0.1, 0.4)
			nomear_objeto(nome_do_aluno, CAIXA_NOME_ALUNO)
			adotar(cadastro_aluno, nome_do_aluno)
			inteiro idade_do_aluno = criar_caixa_texto_editavel("Insira a idade do aluno", 0.5, 0.4, 0.1, 0.4)
			nomear_objeto(idade_do_aluno, CAIXA_IDADE_ALUNO)
			adotar(cadastro_aluno, idade_do_aluno)
			inteiro telefone_do_aluno = criar_caixa_texto_editavel("Insira o telefone do aluno", 0.5, 0.6, 0.1, 0.4)
			nomear_objeto(telefone_do_aluno, CAIXA_TELEFONE_ALUNO)
			adotar(cadastro_aluno, telefone_do_aluno)
		retorne cadastro_aluno
	}

	funcao inteiro criar_estado_listagem_alunos(inteiro alunos_por_pagina) {
		inteiro objeto = criar_objeto()
		ob.atribuir_propriedade(objeto, "pagina", 0)
		ob.atribuir_propriedade(objeto, "alunos", 0)
		ob.atribuir_propriedade(objeto, "alunos_por_pagina", alunos_por_pagina)
		nomear_objeto(objeto, ESTADO_LISTAGEM_ALUNOS)
		retorne objeto
	}

	funcao inteiro construir_listagem_alunos(inteiro alunos_por_pagina, real altura_por_aluno) {
		inteiro estado = criar_estado_listagem_alunos(alunos_por_pagina)
		inteiro tamanho = alunos_por_pagina * altura_por_aluno + 100
		inteiro listagem = construir_caixa_com_label("Listagem de alunos", 0.5, 0.5, tamanho, 0.5)
		atribuir_modoh(listagem, DIMENSIONAMENTO_PX)
		nomear_objeto(listagem, TELA_LISTAGEM_ALUNOS)
			inteiro container_alunos = criar_retangulo(100, 100, alunos_por_pagina * altura_por_aluno, 1)
			nomear_objeto(container_alunos, CONTAINER_LISTAGEM_ALUNOS)
			atribuir_margem_topo(container_alunos, 100)
			atribuir_modoh(container_alunos, DIMENSIONAMENTO_PX)
			adotar(listagem, container_alunos)
			inteiro container_footer = criar_retangulo(0.5, 1, 0.1, 0.2)
				atribuir_margem_topo(container_footer, -5)
				adotar(listagem, container_footer)
					inteiro botao_passar_pagina = criar_botao("Próxima", BOTAO_LISTAGEM_PASSAR_PAGINA, 1, 0.5, 30, 80)
					atribuir_modoh(botao_passar_pagina, DIMENSIONAMENTO_PX)
					atribuir_modow(botao_passar_pagina, DIMENSIONAMENTO_PX)
					atribuir_raio_x(botao_passar_pagina, 4)
					atribuir_raio_y(botao_passar_pagina, 4)
					atribuir_cor(botao_passar_pagina, COR_PRIMARY)
					adotar(container_footer, botao_passar_pagina)
					inteiro botao_voltar_pagina = criar_botao("Anterior", BOTAO_LISTAGEM_VOLTAR_PAGINA, 0, 0.5, 30, 80)
					atribuir_modoh(botao_voltar_pagina, DIMENSIONAMENTO_PX)
					atribuir_modow(botao_voltar_pagina, DIMENSIONAMENTO_PX)
					atribuir_raio_x(botao_voltar_pagina, 4)
					atribuir_raio_y(botao_voltar_pagina, 4)
					atribuir_cor(botao_voltar_pagina, COR_PRIMARY)
					adotar(container_footer, botao_voltar_pagina)
		retorne listagem
	}

	funcao lidar_eventos() {
		para (inteiro i = 0; i < quantidade_eventos; i++) {
			inteiro evento = eventos[i]
			inteiro objeto = ob.obter_propriedade_tipo_inteiro(evento, "objeto")
			se (checar_objeto_fraco(objeto)) {
				inteiro tipo = ob.obter_propriedade_tipo_inteiro(evento, "tipo")
				escolha (tipo) {
				caso EVENTO_MOUSE_ESQUERDO_CLICAR:
					cadeia nome = receber_nome(objeto)
					se (nome == BOTAO_ADICIONAR_ALUNO) {
						botao_adicionar_aluno()
					} senao se (nome == BOTAO_CADASTRO_ALUNOS) {
						botao_cadastro_alunos()
					} senao se (nome == BOTAO_LISTAGEM_ALUNOS) {
						botao_listagem_alunos()
					} senao se (nome == BOTAO_SISTEMA_SAIR) {
						botao_sistema_sair()
					}
				caso contrario:
					pare
				}
			}
		}
	}
	
	funcao inteiro construir_tela_principal() {
		inteiro tela = criar_retangulo(0, 0, 1, 1)
		atribuir_cor(tela, COR_BACKGROUND_GRAY)
			inteiro header = criar_retangulo(0, 0, 50, 1)
			atribuir_modoh(header, DIMENSIONAMENTO_PX)
			atribuir_cor(header, COR_BACKGROUND_LIGHT_GRAY)
			adotar(tela, header)
				inteiro texto = criar_caixa_texto("Sistema de cadastro", 20, 0.5)
				atribuir_modox(texto, DIMENSIONAMENTO_PX)
				atribuir_cor(texto, gf.COR_PRETO)
				atribuir_tamanho_fonte(texto, 30)
				adotar(header, texto)
				inteiro container_botoes = criar_retangulo(0.5, 0.5, 0.8, 0.2)
				atribuir_cor(container_botoes, COR_BACKGROUND_LIGHT_GRAY)
				adotar(header, container_botoes)
					inteiro botao_cadastro = criar_botao("Cadastro de alunos", BOTAO_CADASTRO_ALUNOS, 0, 0.5, 0.8, 160)
					atribuir_raio_x(botao_cadastro, 4)
					atribuir_raio_y(botao_cadastro, 4)
					atribuir_modow(botao_cadastro, DIMENSIONAMENTO_PX)
					atribuir_cor(botao_cadastro, COR_SECONDARY)
					adotar(container_botoes, botao_cadastro)
					inteiro botao_listagem = criar_botao("Listagem de alunos", BOTAO_LISTAGEM_ALUNOS, 1, 0.5, 0.8, 160)
					atribuir_raio_x(botao_listagem, 4)
					atribuir_raio_y(botao_listagem, 4)
					atribuir_modow(botao_listagem, DIMENSIONAMENTO_PX)
					atribuir_cor(botao_listagem, COR_SECONDARY)
					adotar(container_botoes, botao_listagem)
				inteiro botao_sair = criar_botao("Sair", BOTAO_SISTEMA_SAIR, 1, 0.5, 0.5, 50)
				atribuir_margem_esquerda(botao_sair, -10)
				atribuir_raio_x(botao_sair, 4)
				atribuir_raio_y(botao_sair, 4)
				atribuir_modow(botao_sair, DIMENSIONAMENTO_PX)
				atribuir_cor(botao_sair, COR_PERIGO)
				adotar(header, botao_sair)
		inteiro cadastro_aluno = construir_cadastro_aluno()
		atribuir_visivel(cadastro_aluno, falso)
		adotar(tela, cadastro_aluno)
		inteiro listagem_aluno = construir_listagem_alunos(10, 60)
		adotar(tela, listagem_aluno)
		retorne tela
	}
	
	funcao inicio()
 	{
 		inicializar_biblioteca_ui()
		definir_fonte("Roboto")
		inserir_objeto(construir_tela_principal())
		carregar_alunos()
		recarregar_listagem()
		inteiro periodo = 0
		enquanto (nao kb.tecla_pressionada(kb.TECLA_ESC))
		{	
			periodo += tempo_delta
			//se (periodo >= segundos(1)) {
				//periodo = 0
				//definir_janela_dimensoes(ut.sorteia(400, 1920), ut.sorteia(300, 1080))
			//}
			biblioteca_ui_tick()
			lidar_eventos()
			
		}
		biblioteca_ui_finalizar()
	}

	
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 52539; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */