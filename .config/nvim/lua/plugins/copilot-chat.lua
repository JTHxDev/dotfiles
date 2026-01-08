local user = vim.env.USER or "User"
user = user:sub(1, 1):upper() .. user:sub(2)
local prompts = {
    -- Code related prompts
    Explain = "Please explain how the following code works.",
    Review = "Please review the following code and provide suggestions for improvement.",
    Tests = "Please explain how the selected code works, then generate unit tests for it.",
    Refactor = "Please refactor the following code to improve its clarity and readability.",
    FixCode = "Please fix the following code to make it work as intended.",
    FixError = "Please explain the error in the following text and provide a solution.",
    BetterNamings = "Please provide better names for the following variables and functions.",
    Documentation = "Please provide documentation for the following code.",
    SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
    SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
    -- Text related prompts
    Summarize = "Please summarize the following text.",
    Spelling = "Please correct any grammar and spelling errors in the following text.",
    Wording = "Please improve the grammar and wording of the following text.",
    Concise = "Please rewrite the following text to make it more concise.",
    DjangoSecurity = [[
        You're a security-aware Django expert. I am preparing for the Secure Code Warrior certification exam. Please review the following Django code and:
        - Identify any security vulnerabilities (e.g., XSS, SQL Injection, CSRF, etc.)
        - Explain the risk associated with each vulnerability.
        - Suggest a secure, Django-idiomatic way to fix them.
        Here's the code (Python 3.10, Django 4.2):
    ]],

    CommitMessage = {
        prompt = [[
  > #git:staged
  Please generate a git commit message for the following changes. Use the present tense (e.g., 'update' instead of 'updated').
  If any of the information is not available, please set it to null:

  Ensure to include the properties `issuesClosed` and `breakingChanges`. If they do not exist, set them to `null`. Additionally, implement logic to detect any breaking changes in the code. If found, add the reason to the breaking changes.

  Please respond in the following format:
  <type>(<scope>)[<correlationId>]: <subject>

  <body>

  <issues closed>

  <breaking changes>

  This is the git diff:
  {git_diff}

  The below is additional context to help you generate the commit message:

  Commit message inputs:
  When inputting type into your commit message, your type should be one of the following:
  feat: A new feature
  fix: A bug fix
  docs: Documentation-only changes
  style: Changes that do not affect the meaning of the code (e.g., blank spaces, formatting, missing semicolons, etc.)
  refactor: A code change that neither fixes a bug nor adds a feature
  perf: A code change that improves performance
  test: Adding missing tests
  chore: Changes to the build process or auxiliary tools and libraries such as documentation generation

  Scope:
  The scope is anything specifying the place of the commit change such as file, package, or class.

  Correlation ID:
  This is your Jira-issue ID (e.g., CARD-19563) if there is a story associated. Otherwise, use the GitHub issue id (e.g., #10). Create an issue if necessary.

  Subject:
  The subject is a brief description of the change. This means you should:
  - Use the imperative, present tense. For example, write change not changed nor changes.
  - Not capitalize the first letter.
  - Not use a period (.) at the end.

  Body:
  Just as in the subject, write this input in the form of a present-tense command, as if you were telling someone to do something in present time. The body should include a more thorough explanation of the change, including motivation for the change and contrast this with previous behavior.
]],
        system_prompt =
        " you are a very experienced capitalone software engineer who is very good at writting commit messages that are meaningful",
        mapping = '<leader>qC',
    },
}

return {
    --{ import = "plugins.copilot" }, -- Or use { import = "lazyvim.plugins.extras.coding.copilot" },
    {
        "folke/which-key.nvim",
        optional = true,
        opts = {
            spec = {
                { "<leader>q", group = "ai" },
            },
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        optional = true,
        opts = {
            file_types = { "markdown", "copilot-chat" },
        },
        ft = { "markdown", "copilot-chat" },
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        -- version = "v3.3.0", -- Use a specific version to prevent breaking changes
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        opts = {
            question_header = "## User ",
            answer_header = "## Copilot ",
            error_header = "## Error ",
            prompts = prompts,
            model = "gpt-4o",
            mappings = {
                -- Use tab for completion
                complete = {
                    detail = "Use @<Tab> or /<Tab> for options.",
                    insert = "<Tab>",
                },
                -- Close the chat
                close = {
                    normal = "q",
                    insert = "<C-c>",
                },
                -- Reset the chat buffer
                reset = {
                    normal = "<C-x>",
                    insert = "<C-x>",
                },
                -- Submit the prompt to Copilot
                submit_prompt = {
                    normal = "<CR>",
                    insert = "<C-CR>",
                },
                -- Accept the diff
                accept_diff = {
                    normal = "<C-y>",
                    insert = "<C-y>",
                },
                -- Show help
                show_help = {
                    normal = "g?",
                },
            },
        },
        config = function(_, opts)
            local chat = require("CopilotChat")
            local user = vim.env.USER or "User"
            user = user:sub(1, 1):upper() .. user:sub(2)
            opts.question_header = "  " .. user .. " "
            opts.answer_header = "  Copilot "

            chat.setup(opts)

            local select = require("CopilotChat.select")
            vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
                chat.ask(args.args, { selection = select.visual })
            end, { nargs = "*", range = true })

            -- Inline chat with Copilot
            vim.api.nvim_create_user_command("CopilotChatInline", function(args)
                chat.ask(args.args, {
                    selection = select.visual,
                    window = {
                        layout = "float",
                        relative = "cursor",
                        width = 1,
                        height = 0.4,
                        row = 1,
                    },
                })
            end, { nargs = "*", range = true })

            -- Restore CopilotChatBuffer
            vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
                chat.ask(args.args, { selection = select.buffer })
            end, { nargs = "*", range = true })
            -- Take code and select
            vim.api.nvim_create_user_command("CopilotChatDjangoSecurity", function(args)
                chat.ask(prompts.DjangoSecurity .. "\n" .. args.args, { selection = select.visual })
            end, { nargs = "*", range = true })


            -- Custom buffer for CopilotChat
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "copilot-*",
                callback = function()
                    vim.opt_local.relativenumber = true
                    vim.opt_local.number = true

                    -- Get current filetype and set it to markdown if the current filetype is copilot-chat
                    local ft = vim.bo.filetype
                    if ft == "copilot-chat" then
                        vim.bo.filetype = "markdown"
                    end
                end,
            })
        end,
        event = "VeryLazy",
        keys = {
            -- Show prompts actions
            {
                "<leader>qs",
                "<cmd>CopilotChatDjangoSecurity<cr>",
                desc = "CopilotChat - Django Security Review"
            },

            {
                "<leader>qq",
                function()
                    require("CopilotChat").toggle()
                end,
                desc = "CopilotChat - Toggle window",
            },
            {
                "<leader>qp",
                function()
                    require("CopilotChat").select_prompt({
                        context = {
                            "buffers",
                        },
                    })
                end,
                desc = "CopilotChat - Prompt actions",
            },
            {
                "<leader>qp",
                function()
                    require("CopilotChat").select_prompt()
                end,
                mode = "x",
                desc = "CopilotChat - Prompt actions",
            },
            -- Code related commands
            { "<leader>qe", "<cmd>CopilotChatExplain<cr>",       desc = "CopilotChat - Explain code" },
            { "<leader>qt", "<cmd>CopilotChatTests<cr>",         desc = "CopilotChat - Generate tests" },
            { "<leader>qr", "<cmd>CopilotChatReview<cr>",        desc = "CopilotChat - Review code" },
            { "<leader>qR", "<cmd>CopilotChatRefactor<cr>",      desc = "CopilotChat - Refactor code" },
            { "<leader>qn", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
            -- Chat with Copilot in visual mode
            {
                "<leader>qv",
                ":CopilotChatVisual",
                mode = "x",
                desc = "CopilotChat - Open in vertical split",
            },
            {
                "<leader>qx",
                ":CopilotChatInline",
                mode = "x",
                desc = "CopilotChat - Inline chat",
            },
            -- Custom input for CopilotChat
            {
                "<leader>qi",
                function()
                    local input = vim.fn.input("Ask Copilot: ")
                    if input ~= "" then
                        vim.cmd("CopilotChat " .. input)
                    end
                end,
                desc = "CopilotChat - Ask input",
            },
            -- Generate commit message based on the git diff
            {
                "<leader>qm",
                "<cmd>CopilotChatCommit<cr>",
                desc = "CopilotChat - Generate commit message for all changes",
            },
            -- Quick chat with Copilot
            {
                "<leader>qc",
                function()
                    local input = vim.fn.input("Quick Chat: ")
                    if input ~= "" then
                        vim.cmd("CopilotChatBuffer " .. input)
                    end
                end,
                desc = "CopilotChat - Quick chat",
            },
            -- Fix the issue with diagnostic
            { "<leader>qf", "<cmd>CopilotChatFixError<cr>", desc = "CopilotChat - Fix Diagnostic" },
            -- Clear buffer and chat history
            { "<leader>ql", "<cmd>CopilotChatReset<cr>",    desc = "CopilotChat - Clear buffer and chat history" },
            -- Toggle Copilot Chat Vsplit
            { "<leader>qv", "<cmd>CopilotChatToggle<cr>",   desc = "CopilotChat - Toggle" },
            -- Copilot Chat Models
            { "<leader>q?", "<cmd>CopilotChatModels<cr>",   desc = "CopilotChat - Select Models" },
            -- Copilot Chat Agents
            { "<leader>qa", "<cmd>CopilotChatAgents<cr>",   desc = "CopilotChat - Select Agents" },
        },
    },
}
