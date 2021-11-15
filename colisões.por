programa
{
	inclua biblioteca Util --> ut
	inclua biblioteca Matematica --> mt
	inclua biblioteca Teclado --> kb
	inclua biblioteca Mouse --> mo
	inclua biblioteca Graficos --> gf
	
	

	const inteiro COLISAO_DENTRO = 0
	const inteiro COLISAO_FORA = 1
	const inteiro COLISAO_DENTRO_FORA = 2
	const inteiro COLISAO_FORA_DENTRO = 3
	const inteiro COLISAO_IMPOSSIVEL = 4

	inteiro cronometro_inicio
	funcao cronometro_comecar() {
		cronometro_inicio = ut.tempo_decorrido()
	}

	funcao cronometro_finalizar(cadeia id) {
		escreva("\n[" + id + "]" + " Tempo decorrido " + (ut.tempo_decorrido() - cronometro_inicio))
		cronometro_inicio = 0
	}

	funcao logico colisao_quadrado_ponto(inteiro x, inteiro y, inteiro h, inteiro w, inteiro x2, inteiro y2) {
		retorne x2 >= x e x2 <= x + w e y2 >= y e y2 <= y + h
	}

	funcao inteiro colisao_quadrado_quadrado(inteiro x, inteiro y, inteiro h, inteiro w, inteiro x2, inteiro y2, inteiro h2, inteiro w2) {
		// Incompleto...
		logico xy = colisao_quadrado_ponto(x, y, h, w, x2, y2)
		logico xh = colisao_quadrado_ponto(x, y, h, w, x2, y2 + h2)
		logico wh = colisao_quadrado_ponto(x, y, h, w, x2 + w2, y2 + h2)
		logico wy = colisao_quadrado_ponto(x, y, h, w, x2 + w2, y2)
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

	funcao logico colisao_retangulo_circulo(inteiro x, inteiro y, inteiro w, inteiro h, inteiro cx, inteiro cy, inteiro r) {
		inteiro x_direita = cx + r
		inteiro x_esquerda = cx - r
		inteiro y_cima = cy - r
		inteiro y_baixo = cy + r
		se (colisao_quadrado_ponto(x, y, h, w, x_direita, cy) ou
		    colisao_quadrado_ponto(x, y, h, w, x_esquerda, cy) ou
		    colisao_quadrado_ponto(x, y, h, w, cx, y_cima) ou
		    colisao_quadrado_ponto(x, y, h, w, cx, y_baixo)) {
		    	retorne verdadeiro
		}
		inteiro qx_direita = x + h
		inteiro qy_baixo = y + h
		se (colisao_ponto_circulo(x, y, cx, cy, r) ou
		    colisao_ponto_circulo(qx_direita, y, cx, cy, r) ou
		    colisao_ponto_circulo(x, qy_baixo, cx, cy, r) ou
		    colisao_ponto_circulo(qx_direita, qy_baixo, cx, cy, r)) {
			retorne verdadeiro    	
		}
		retorne falso
	}

	funcao logico colisao_ponto_circulo(inteiro x, inteiro y, inteiro cx, inteiro cy, inteiro r) {
		inteiro primeiro = (x - cx)
		inteiro segundo = (y - cy)
		retorne primeiro * primeiro + segundo * segundo < r * r
	}

	funcao desenhar_circulo(inteiro cx, inteiro cy, inteiro r, logico p) {
		gf.desenhar_elipse(cx - r, cy - r, 2*r, 2*r, p)
	}
	
	funcao inicio()
	{
		gf.iniciar_modo_grafico(verdadeiro)
		gf.definir_dimensoes_janela(1000, 800)
		inteiro qx = 500
		inteiro qy = 500
		inteiro qh = 100
		inteiro qw = 100
		inteiro qh2 = 50
		inteiro qw2 = 50
		inteiro cx = 200
		inteiro cy = 300
		inteiro r = 100
		enquanto(nao kb.tecla_pressionada(kb.TECLA_ESC)) {
			inteiro mousex = mo.posicao_x()
			inteiro mousey = mo.posicao_y()
			inteiro qx2 = mousex - qw2/2
			inteiro qy2 = mousey - qh2/2
			escolha(colisao_quadrado_quadrado(qx, qy, qh, qw, qx2, qy2, qh2, qw2)) {
				caso COLISAO_DENTRO:
					gf.definir_cor(gf.COR_VERMELHO)
					pare
				caso COLISAO_FORA:
					gf.definir_cor(gf.COR_BRANCO)
					pare
				caso COLISAO_DENTRO_FORA:
					gf.definir_cor(gf.COR_VERDE)
					pare
				caso COLISAO_FORA_DENTRO:
					gf.definir_cor(gf.COR_AMARELO)
					pare
				caso contrario:
					gf.definir_cor(gf.COR_AZUL)
					pare
			}
			escreva("\nqx " + qx, " qy " +  qy, " qh " + qh, " qw " + qw, " qx2 " + qx2, " qy2 " + qy2, " qh2 " + qh2, " qw2 " + qw2)
			gf.desenhar_retangulo(qx, qy, qw, qh, falso, verdadeiro)
			gf.definir_cor(gf.COR_BRANCO)
			gf.desenhar_retangulo(qx2, qy2, qw2, qh2, falso, verdadeiro)
			se (colisao_retangulo_circulo(qx2, qy2, qw2, qh2, cx, cy, r)) {
				gf.definir_cor(gf.COR_VERMELHO)
			} senao {
				gf.definir_cor(gf.COR_BRANCO)
			}
			desenhar_circulo(cx, cy, r, verdadeiro)
			gf.definir_cor(gf.COR_VERDE)
			gf.desenhar_ponto(cx, cy)
			gf.definir_cor(gf.COR_AMARELO)
			gf.desenhar_ponto(mousex, mousey)
			gf.renderizar()
		}
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 960; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */