class Task < ApplicationRecord
  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: %w[pendente em_progresso concluida falha] }
  validates :url, presence: true, format: { with: URI::regexp(%w[http https]), message: "must be a valid URL" }
end
