FROM ruby:3.2.2

# Instala dependências
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Define o diretório de trabalho
WORKDIR /app

# Copia o Gemfile e o Gemfile.lock e instala as gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copia o restante do código
COPY . .

# Expõe a porta padrão
EXPOSE 3001

# Comando padrão para executar o servidor Rails
CMD ["rails", "server", "-b", "0.0.0.0"]
