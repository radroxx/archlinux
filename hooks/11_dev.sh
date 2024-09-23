
function install_pkgs_list()
{
    pkgs="$pkgs base-devel d-runtime git-lfs act"

    pkgs="$pkgs binwalk"

    # windows tools
    pkgs="$pkgs wimlib chntpw"

    # DBs
    pkgs="$pkgs postgresql-libs percona-server-clients redis csvkit"

    # kuberneties
    pkgs="$pkgs k9s kubectl helm krew"

    # android dev
    pkgs="$pkgs android-tools android-udev"

    # java
    pkgs="$pkgs jdk-openjdk jdk8-openjdk"

    # js
    pkgs="$pkgs npm yarn"

    # utils
    pkgs="$pkgs cmake protobuf gnuplot ninja"



    # tools
    vs_code_pkgs="formulahendry.code-runner"
    vs_code_pkgs="$vs_code_pkgs aaron-bond.better-comments alefragnani.Bookmarks"
    vs_code_pkgs="$vs_code_pkgs Gruntfuggly.todo-tree carlos-algms.make-task-provider ms-vscode.makefile-tools"
    vs_code_pkgs="$vs_code_pkgs marduc812.nmap-peek"

    # yaml and xml
    pkgs="$pkgs yaml-language-server"
    vs_code_pkgs="$vs_code_pkgs redhat.vscode-yaml redhat.vscode-xml"

    # git
    vs_code_pkgs="$vs_code_pkgs eamodio.gitlens mhutchie.git-graph"

    # fs
    vs_code_pkgs="$vs_code_pkgs thingalon.pony-ssh arcanis.vscode-zipfs"

    # themes
    vs_code_pkgs="$vs_code_pkgs GitHub.github-vscode-theme dracula-theme.theme-dracula monokai.theme-monokai-pro-vscode zhuangtongfa.material-theme"

    # speel
    vs_code_pkgs="$vs_code_pkgs streetsidesoftware.code-spell-checker streetsidesoftware.code-spell-checker-british-english"
    vs_code_pkgs="$vs_code_pkgs streetsidesoftware.code-spell-checker-russian"

    # openapi
    vs_code_pkgs="$vs_code_pkgs 42Crunch.vscode-openapi"
        
    # drawio
    vs_code_pkgs="$vs_code_pkgs hediet.vscode-drawio"

    # Markdown
    vs_code_pkgs="$vs_code_pkgs shd101wyy.markdown-preview-enhanced"
        
    # font preview
    vs_code_pkgs="$vs_code_pkgs adamraichu.font-viewer"

    # geo data view
    vs_code_pkgs="$vs_code_pkgs RandomFractalsInc.geo-data-viewer"
        
    # liveserver and live browser
    vs_code_pkgs="$vs_code_pkgs ritwickdey.LiveServer auchenberg.vscode-browser-preview"

    # 3d modules
    vs_code_pkgs="$vs_code_pkgs slevesque.vscode-3dviewer Antyos.openscad Leathong.openscad-language-support"
    # aur openscad-lsp

    # database
    #code_pkgs += qwtel.sqlite-viewer
    #code_pkgs += mtxr.sqltools mtxr.sqltools-driver-sqlite mtxr.sqltools-driver-pg mtxr.sqltools-driver-mysql

    # csv and data
    vs_code_pkgs="$vs_code_pkgs mechatroner.rainbow-csv RandomFractalsInc.vscode-data-preview"

    # toml
    vs_code_pkgs="$vs_code_pkgs tamasfe.even-better-toml"

    # docker file
    vs_code_pkgs="$vs_code_pkgs jeff-hykin.better-dockerfile-syntax"

    # shell
    vs_code_pkgs="$vs_code_pkgs jeff-hykin.better-shellscript-syntax"

    # python
    pkgs="$pkgs jedi-language-server"
    vs_code_pkgs="$vs_code_pkgs ms-python.python"

    # cpp
    pkgs="$pkgs gcc gdb clang lldb"
    vs_code_pkgs="$vs_code_pkgs llvm-vs-code-extensions.vscode-clangd jeff-hykin.better-cpp-syntax franneck94.c-cpp-runner"

    # golang
    pkgs="$pkgs go gopls staticcheck delve"
    vs_code_pkgs="$vs_code_pkgs golang.go"
    # aur gotests gomodifytags

    # rust
    pkgs="$pkgs rust rust-analyzer"
    vs_code_pkgs="$vs_code_pkgs rust-lang.rust-analyzer"

    # java
    vs_code_pkgs="$vs_code_pkgs redhat.java vscjava.vscode-java-debug vscjava.vscode-java-test"
    # aur jdtls

    # kotlin
    pkgs="$pkgs kotlin"
    vs_code_pkgs="$vs_code_pkgs fwcd.kotlin"
    # aur kotlin-language-server

    # dotnet
    pkgs="$pkgs mono dotnet-runtime dotnet-sdk"
    vs_code_pkgs="$vs_code_pkgs ms-dotnettools.vscode-dotnet-runtime muhammad-sammy.csharp"
    # aur netcoredbg

    #code_pkgs += minamarkham.yonce-theme

}

function post_install_hook()
{
    mkdir -p /usr/lib/code/extensions

	# install code extension
	echo "${vs_code_pkgs}" | tr " " "\n" | xargs -n1 -t -I {} /usr/bin/xvfb-run /usr/bin/code-oss --no-sandbox --extensions-dir /usr/lib/code/extensions --install-extension {}
	/usr/bin/xvfb-run /usr/bin/code-oss --no-sandbox --extensions-dir /usr/lib/code/extensions --install-extension /var/cache/hooks/11_dev/codelldb-x86_64-linux.vsix

}