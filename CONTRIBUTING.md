# Contribuindo para o LSP-Compass

Obrigado por querer contribuir com o **LSP-Compass**!
Este projeto tem como objetivo melhorar a integração de servidores LSP no Neovim, de forma simples e automática.

## Como contribuir

1. **Faça um fork** do repositório:

   ```bash
   git clone https://github.com/seu-usuario/lsp-compass
   cd lsp-compass
   git checkout -b minha-feature
   ```

2. **Implemente sua modificação**:

   * Mantenha o código limpo e comentado.
   * Use nomes de variáveis e funções claros.
   * Respeite o estilo usado nas outras partes do projeto (Lua).

3. **Teste localmente:**

   * Abra o Neovim carregando o plugin com:

     ```bash
     nvim --cmd "set rtp+=."
     ```
   * Verifique se o comportamento do plugin está correto.

4. **Documente as alterações**:

   * Atualize o `README.md` se a funcionalidade for nova.
   * Inclua exemplos de uso quando necessário.
   * Adicione notas relevantes no `CHANGELOG.md`.

5. **Envie um Pull Request (PR)**:

   * Descreva de forma clara **o que** e **por que** mudou.
   * Mencione se há impacto em compatibilidade ou dependências.

---

## Dicas para testar

Para simular a detecção e sugestão de LSPs:

```lua
:lua print(vim.bo.filetype)
:lua require("lsp-compass").suggest()
```

Caso o plugin falhe:

* Verifique o nome retornado por `vim.bo.filetype`.
* Confirme se o LSP sugerido está instalado (`:Mason` → procurar o servidor).
* Reporte o erro com o máximo de contexto possível.

---

## Boas práticas de comunicação

* Use linguagem respeitosa e objetiva nas issues.
* Prefira títulos descritivos:
   “Erro na sugestão do LSP para arquivos .cpp”
   “Bug”
* Evite PRs muito grandes; prefira mudanças pequenas e claras.
* Sinta-se à vontade para abrir **issues de dúvida** — feedbacks também são contribuição!

---

## Licença

Ao contribuir, você concorda que suas alterações serão distribuídas sob a mesma licença do projeto (MIT).
