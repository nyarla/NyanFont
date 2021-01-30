all: \
	out/Nyan-Monospace-Regular.ttf

clean:
	rm -rf out/*.sfd
	rm -rf out/*.ttx
	rm -rf out/*.ttf

out/Nyan-Monospace-Regular.ttf:
	@$(MAKE) monospace \
		BASE=src/GenJyuuGothicX-Monospace-Regular.ttf \
		OVERLAY=src/rounded-x-mplus-2m-regular.ttf \
		ASCII=src/Inconsolata-Regular.ttf \
		DST=out/Nyan-Monospace-Regular.ttf

monospace:
	@$(MAKE) base SRC=$(BASE) DST=out/monospace-base.sfd
	@$(MAKE) overlay SRC=$(OVERLAY) DST=out/monospace-overlay.sfd
	@$(MAKE) ascii SRC=$(ASCII) DST=out/monospace-ascii.sfd
	@fontforge -lang=ff -script scripts/monospace.pe \
		out/monospace-base.sfd \
		out/monospace-overlay.sfd \
		out/monospace-ascii.sfd \
		out/monospace.ttf
	@ttx -t "OS/2" out/monospace.ttf
	@sed -i 's!<xAvgCharWidth value="574"/>!<xAvgCharWidth value="512"/>!' out/monospace.ttx
	@ttx -m out/monospace.ttf -o $(DST) out/monospace.ttx

base:
	@fontforge -lang=ff -script scripts/base.pe $(SRC) $(DST)

overlay:
	@fontforge -lang=ff -script scripts/overlay.pe $(SRC) $(DST)

ascii:
	@fontforge -lang=ff -script scripts/ascii.pe $(SRC) $(DST)

shell:
	@nix-shell -p fontforge -p python38Packages.fonttools
