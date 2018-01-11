#!/bin/bash 
# Como rodar o script de release
#
# pre-requisitos:
#  - yarn https://yarnpkg.com/pt-BR/
#  - instalar os pacotes: `yarn install -g semver rimraf conventional-recommended-bump conventional-changelog-cli conventional-github-releaser conventional-commits-detector json`
#  - ter o client de git-flow: https://danielkummer.github.io/git-flow-cheatsheet/index.pt_BR.html
#  - ter o client de git
# modo de uso:
#  as opções mais utilizadas serão:
#  - bash release.bash release
#	 - bash release.bash prerelease
#
#  voce pode sobrescrever a detecção do tipo de release executando o segundo e terceiro argumento opcional
#  bash release.bash release/prerelease `patch`/`minor`/`major` <preset>
#  por padrão ele utililiza o conventional-recommended-bump
#  o preset (metodo de deteção de mudança de versão) pode ser `angular`/ `jquery` ...
#  o padrão é conventional-commits-detector
#
# Para autenticar no github com o releaser vá ao link do repositório (https://github.com/conventional-changelog/conventional-github-releaser)
# A função criada no script foi feito uma melhoria para trabalhar com conceito de pre-release, aonde no git-flow não podemos fechar uma release, 
# pois existem ainda necessidades e mais melhorias a serem colocadas antes de fecharmos a release completa, o que dificulta no dia a dia, pois a release
# é o conteúdo com todas as funcionalidades devidamente vinculadas, e é replicado no master, se usarmos uma release pre fazer a pre-release, teremos no master
# a ultima pre-release e não a última versão estável do código, o que vai invalidar o trabalho do hotfix.


# funcao base para gerar release/prerelease, funcao que ambos os metodos utilizam
function prepare {
	echo "entrando no branch develop"
	git checkout develop 
	echo "enviando conteudo em staging para o repositório"
	git push &&
	echo "Apagando node_modules" 
	rimraf node_modules 
	echo "git pull --rebase" 
	git pull --rebase 
	echo "yarn install" 
	yarn install 
	echo "yarn test" 
	yarn test 
	cp package.json _package.json 
	preset=$(conventional-commits-detector) 
	bump=$(conventional-recommended-bump -p ${3:-$preset}) 
}

function release {
	npm --no-git-tag-version version ${2:-$bump} 
	conventional-changelog -i CHANGELOG.md -s -p ${3:-$preset} 
	git add CHANGELOG.md 
	version=$(json -f package.json version) 
	git commit -m"docs(CHANGELOG): $version" 
	mv -f _package.json package.json 
	# executando git flow somente para inicializar o fluxo de release que será finalizado manualmente para não gerar a tag por ele
	git flow release start $version
	npm version ${2:-$bump} -m "chore(release): %s" 
	# enviando release para o github
	conventional-github-releaser -p ${3:-$preset} 
	git checkout develop  
	git merge --no-ff --no-edit release/$version 
	git checkout master 
	git merge --no-ff --no-edit release/$version 
	git push origin develop master --follow-tags
	git checkout develop
	git branch -D release/$version
}

function prerelease {
	oldVersion=$(json -f package.json version)
	# toda versao pre-release sera uma previa do que está querendo atingir com as alteracoes, entao tera prefixo pre no $bump
	# logo um $bump que for recomendado pra ser uma minor será preminor e assim por diante.
	if [ "$bump" = "patch" ]; then
		#os patchs serão tratados como pequenas pre-releases
		bump='release'
	fi
	version=$(semver ${oldVersion}  --no-git-tag-version -i pre${2:-$bump} --preid rc)
	npm --no-git-tag-version version ${version} 
	conventional-changelog -i CHANGELOG.md -s -p ${3:-$preset} 
	git add CHANGELOG.md 
	git commit -m"docs(CHANGELOG): $version" 
	mv -f _package.json package.json 
	# nao teremos release do git-flow, somente controle de tag para criar a pre-release
	npm version ${version} -m "chore(pre-release): %s" 
	# enviando pre-release para o github
	conventional-github-releaser -p ${3:-$preset}
	git push origin develop --follow-tags
}

if [ "$1" = "release" ]; then
	prepare 
	release
elif [ "$1" = "prerelease" ]; then
	prepare 
	prerelease
else
	echo "use somente as opcoes release / pre-release no primeiro argumento"
fi
