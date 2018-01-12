# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rbernand <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/06/18 15:59:40 by rbernand          #+#    #+#              #
#    Updated: 2015/06/21 17:09:26 by rbernand         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME=tic-tac-toe-tic-tac
SRC=Player.ml \
	Board.ml \
	main.ml
OBJ_DIR=obj/
FLAGS=
OBJ=$(SRC:.ml=.cmo)
OPTOBJ=$(SRC:.ml=.cmx)
OPTOBJ=$(SRC:.ml=.cmx)
INTER=Board.mli
INTEROBJ=$(INTER:.mli=.cmi)

CAMLC=ocamlc
CAMLOPT=ocamlopt
CAMLDEP=ocamldep

LIb=
WITHGAPHICS=graphics.cma -cclib -lGraphics

all: depend $(NAME)
	ln -fs $(NAME).byt $(NAME)

$(NAME): $(INTEROBJ) opt byt

opt: $(NAME).opt
byt: $(NAME).byt

$(NAME).opt: $(OPTOBJ)
	$(CAMLOPT) -o $@ $(LIB:.cma=.cmxa) $^ $(FLAGS)

$(NAME).byt: $(OBJ)
	$(CAMLC) -o $@ $(LIB) $^ $(FLAGS)

.SUFFIXES: .ml mli .cmo .cmi .cmx

.ml.cmo:
	$(CAMLC) -c $< $(FLAGS)

%.cmi: %.mli
	$(CAMLC) -c $< $(FLAGS)

.ml.cmx:
	$(CAMLOPT) -c $<

clean:
	rm -f *.cm[iox]
	rm -f $(SRC:.ml=.o)

fclean: clean
	rm -f $(NAME)
	rm -f $(NAME).byt
	rm -f $(NAME).opt

depend: .depend
	$(CAMLDEP) *.mli $(SRC) > .depend

re: fclean all

include .depend
