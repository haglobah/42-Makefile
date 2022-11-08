NAME := forty_two

SRCS := 42.c
MAIN = main.c
OBJS = $(SRCS:.c=.o)
MO = main.o
TESTS = test.c test_main.c
TOBJS = $(TESTS:.c=.o)
TEST = $(NAME)_test

CC := cc
CFLAGS := -Wall -Wextra -Werror # -I../LeakSanitizer/include -L../LeakSanitizer -llsan -lc++

LIBFT := libft
LFT := $(LIBFT)/libft.a

RM := rm -rf

all : $(NAME)

$(LIBFT) :
	git clone https://github.com/haglobah/libft.git

$(LFT) : $(LIBFT)
	$(MAKE) -C $(LIBFT)

$(NAME) : $(MAIN) $(SRCS) Makefile $(NAME).h $(LFT)
	$(CC) $(CFLAGS) $(SRCS) $(LFT) -o $(NAME)

clean :
	@$(RM) $(OBJS) $(MO) $(TOBJS)

fclean : clean
	@$(RM) $(NAME) $(TEST)

re : fclean
	@$(MAKE) all

run : all
	./$(NAME)

lsan : CFLAGS += -I../LeakSanitizer/include -L../LeakSanitizer -llsan -lc++
	$(MAKE) all
	./$(NAME)

test : $(TESTS) $(SRCS)
	$(CC) $(TESTS) $(SRCS) $(LINK_FLAGS) -o $(TEST)
	./$(TEST)

checkup :
    echo "Testing..."
    $(MAKE) test
    echo "Checking for memory leaks..."
    $(MAKE) lsan
    echo "Did you read the subject again, and have checked/asked for common mistakes?"
    norminette *.c $(NAME).h

submit :
ifdef REPO
    git remote add submit $(REPO)
    git remote -v
else
    @echo -e "You have to provide a repo:\n\n     make REPO=<the vogsphere repo> submit\n"
endif

.PHONY: all clean fclean re run test checkup submit