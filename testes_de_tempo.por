programa
{
	inclua biblioteca Util --> u
	inclua biblioteca Graficos --> g
	inclua biblioteca Matematica --> m

	funcao inicio()
	{
       inteiro segundo = 1000
       inteiro tempoTeste = segundo * 20 // 10 segundos de teste

       inteiro LARGURA_TELA = 1920
       inteiro ALTURA_TELA = 1080

       g.iniciar_modo_grafico(verdadeiro)
       g.definir_dimensoes_janela(LARGURA_TELA, ALTURA_TELA)
       g.definir_titulo_janela("Título da janela")
       g.entrar_modo_tela_cheia()

       inteiro tempoExecucao = 0
       inteiro x = 0
       inteiro y = 0
       inteiro tamanho = 100

       inteiro larguraFrame = 43 // cada imagem dos carros tem 43 pixels de largura

       inteiro deltaTempo = 1

       enquanto (tempoExecucao < tempoTeste)
       {
           inteiro inicio = u.tempo_decorrido()
           g.definir_cor(g.COR_PRETO)
           g.limpar()

           g.definir_cor(g.COR_AZUL)
           g.desenhar_retangulo(LARGURA_TELA - tamanho - x, ALTURA_TELA - tamanho - y, tamanho, tamanho, falso, verdadeiro)

           g.definir_cor(g.COR_AMARELO)
           g.desenhar_elipse(x, ALTURA_TELA - tamanho / 2 - y, tamanho / 2, tamanho / 2, verdadeiro)

           //desenha uma cruz/mira no centro da janela usando pontos e uma linha
           g.definir_cor(Graficos.COR_VERMELHO)
           const inteiro tamanhoMira = 21
           para (inteiro i = 0; i < tamanhoMira; i++)
           {
               g.desenhar_ponto(LARGURA_TELA / 2 - tamanhoMira / 2 + i, ALTURA_TELA / 2) // linha horizontal
           }
           g.desenhar_linha(LARGURA_TELA / 2, ALTURA_TELA / 2 - tamanhoMira / 2, LARGURA_TELA / 2, ALTURA_TELA / 2 + tamanhoMira / 2)

           g.definir_cor(Graficos.COR_BRANCO)
           g.definir_tamanho_texto(36)

           cadeia nomeFonte = "Verdana"
           g.definir_fonte_texto(nomeFonte)
           g.definir_estilo_texto(falso, verdadeiro, verdadeiro)
           inteiro larguraTexto = g.largura_texto(nomeFonte)
           inteiro textoY = ALTURA_TELA / 2 + tamanhoMira * 2
           g.desenhar_texto(LARGURA_TELA / 2 - larguraTexto / 2, textoY, nomeFonte)

           inteiro alturaTexto = g.altura_texto(nomeFonte)
           nomeFonte = "Times new Roman"
           g.definir_fonte_texto(nomeFonte)
           g.definir_tamanho_texto(60)
           g.definir_cor(0xFF0000)
           g.definir_estilo_texto(falso, verdadeiro, falso)
           larguraTexto = g.largura_texto(nomeFonte)
           textoY += alturaTexto
           g.desenhar_texto(LARGURA_TELA / 2 - larguraTexto / 2, textoY, nomeFonte)

           nomeFonte = "Star Jedi Hollow"
           g.definir_cor(Graficos.COR_BRANCO)
           g.definir_fonte_texto(nomeFonte)
           larguraTexto = g.largura_texto(nomeFonte)
           textoY += alturaTexto
           g.desenhar_texto(LARGURA_TELA / 2 - larguraTexto / 2, textoY, nomeFonte)
           g.definir_cor(Graficos.COR_BRANCO)
           g.definir_tamanho_texto(14)
           g.definir_fonte_texto("Verdana")
           se (deltaTempo != 0 ) {
               g.desenhar_texto(600, 0, "Fps: " +  (segundo / deltaTempo))
           }
           inteiro img1 = g.renderizar_imagem(LARGURA_TELA, ALTURA_TELA)
           const inteiro carros = 5
           para (inteiro i = 0; i < carros; i++)
           {
               inteiro pos = (x * m.potencia(i, 1.1))
               g.desenhar_retangulo(pos, ALTURA_TELA - 96 - i * larguraFrame, larguraFrame, 96, falso, verdadeiro)
               inteiro img = g.renderizar_imagem(larguraFrame, 96)
               g.desenhar_imagem(0, 0, img)
               g.liberar_imagem(img)
           }
           g.definir_cor(Graficos.COR_VERDE)
           g.definir_rotacao(45)
           g.desenhar_retangulo(x, y, 100, 100, verdadeiro, verdadeiro)
           g.definir_opacidade(255)
           g.definir_rotacao(0)

           x += 2
           y += 2

           se (x > LARGURA_TELA)
           {
               x = 0
           }

           se (y > ALTURA_TELA)
           {
               y = 0
           }
		 inteiro img2 = g.renderizar_imagem(LARGURA_TELA, ALTURA_TELA)
		 g.desenhar_imagem(0, 0, img1)
		 g.desenhar_imagem(0, 0, img2)
		 g.liberar_imagem(img1)
		 g.liberar_imagem(img2)
           g.renderizar()
           deltaTempo = u.tempo_decorrido() - inicio
           tempoExecucao += deltaTempo
       }
       g.fechar_janela()
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 3616; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */