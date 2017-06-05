#!/usr/bin/env julia

# print out a page full of the same glyph in different fonts
# resizing each one to be the same width/height

# hardcoded list of fonts, handpicked for ampersandy goodness
fontslist = [
"Aachen-Bold", "AcademyEngravedLetPlain", "ACaslonPro-Semibold", "AGaramondPro-Bold", "Agenda-Medium", "AkzidenzGroteskBQ-BdCnd", "AlbertusMTStd", "AlgerianCondensedLET", "Americana", "AmericanTypewriterStd-Light", "AmplitudeCond-Light", "AnnaStd", "AnonymousPro", "AntiqueOliveStd-Roman", "ArcherPro-Bold", "ArialUnicodeMS", "ArnoldBoecklin", "AvantGarde-Book", "Avenir-Roman", "BankGothic-Light", "BaseNineB", "BaseTwelveSansB", "Baskerville", "BebasNeue", "BellCentennialStd-BdListing", "BellGothicStd-Black", "Bello-Script", "BelweStd-Medium", "BemboStd", "BenguiatStd-Book", "BenguiatGothic-BookOblique", "BernhardModernStd-Bold", "BickhamScriptPro-Regular", "BigCaslon-Medium", "BitstreamVeraSansMono-Bold", "Bodoni-Poster", "Bodoni-PosterCompressed", "BodoniStd", "BrandonGrotesque-Thin", "BrushScript", "CaeciliaLTStd-Bold", "Campanile", "CasablancaLHF", "Caslon3LTStd-Italic", "Caslon224Std-Black", "CaslonTwoTwentyFour-Black", "CenturyGothic", "CenturyOldStyle-Bold", "Chalkboard", "Champion-HTF-Bantamweight", "Charcoal", "CheltenhamStd-Book", "ChocICG", "ChopinScript", "ChronicleTextG1-Roman", "CircularStd-Medium", "Cochin-BoldItalic", "Code2000", "CooperBlackStd", "CopperplateGothic-Bold", "CorpidOffice-Bold", "Courier", "CutiveMono-Regular", "DejaVuSans", "DINNextLTPro-Regular", "DINPro-Regular", "DomCasualStd", "DorchesterScriptMTStd", "DTLFleischmann-DRegular", "DTLNobelT-Bold", "DTLProkyonSTBold", "Duvall", "EncorpadaClassic-Black", "EnvyCodeR", "EurostileLTStd", "EversonMono", "FagoOfficeSerif-Bold", "FantasqueSansMono-RegItalic", "FilosofiaGrandOT-Bold", "FiraMonoOT", "FiraSansOT", "Formata-Bold", "Forza-Medium", "FranklinGothicStd-Roman", "FrizQuadrataStd", "FrutigerLTStd-Roman", "FuturaStd-Book", "FuturaStd-Condensed", "GadgetRegular", "Geneva", "Georgia", "GillSansMT", "GillSansStd-UltraBold", "GothamBlack", "GothamBook", "GothamCondensed-Book", "GoudyModernMTStd", "GoudySansStd-Black", "GoudyStd", "GoudyStout", "Helvetica", "Helvetica-Neue", "Hermit-bold", "HoboStd", "HouseGothicHG23Ext-BOLD1", "Impact", "Inconsolata-Bold", "IndustriaLTStd-Solid", "InputMono-Black", "InputSans-Black", "InputSerif-Black", "Interstate", "ITCAvantGardeStd-Bk", "ITCFranklinGothicStd-Med", "ITCKabelStd-Book", "JoannaMTStd-Bold", "Knockout-HTF51-Middleweight", "Knox", "Korinna-Bold", "Kosmik-BoldOne", "LaserICG", "Lato-Regular", "Lavoisier", "LeagueGothic", "LegacySansStd-Bold", "LetterGothicMTStd", "LexiconNo1ItalicD-Txt", "LHFAmbrosia", "LHFLarcherRoman", "LiberationMono", "LucidaCalligraphy-Italic", "LucidaSansUnicode", "Luculent", "Lust-Regular", "MatrixInlineExtraBold", "MeridienLTStd-Bold", "MetaPro-Book", "Miller-Text", "MiltonMN", "MinionPro-Regular", "MissionScript", "MistralStd", "Monaco", "Monofonto", "Monofur", "Motter-Ombra", "MotterCorpusStd-Condensed", "MrsEavesOT-Roman", "MuseoSlab-500", "NeutraText-Book", "NeuzeitSLTStd-Book", "NewsGothicStd", "NovaMono", "OCRA", "OCRB", "OpenSans", "Optima-Regular", "Osaka", "Osaka-Mono", "OxygenMono-Regular", "P22BayerUniversal", "P22CezannePro", "P22JohnstonUnderground", "PalaceScriptMT-Std", "Palatino-Roman", "PalatinoLinotype-Bold", "PeignotLTStd-Demi", "Perla", "PerpetuaStd", "Pistilli", "PosterCut-Regular", "PrestigeEliteStd", "ProggySmallTT", "ProggyTinyTT", "ProximaNova-Regular", "PTMono-Bold", "Reina12Standard", "ReinaEngravedPro", "Roboto-Medium", "RockwellStd-Bold", "RomicStd-Medium", "RunicMT-Condensed", "Scala-Italic", "SegoeUI", "Sentinel-Black", "SerifGothicStd", "Share-TechMono", "SinhalaMN-Bold", "SnellRoundhand-BlackScript", "Sofachrome", "SourceCodePro-Black", "SouvenirStd-Light", "SteepTypewriter-Medium", "Stilla", "StoneSansStd-Medium", "StoneSerifStd-Medium", "Superclarendon-Black", "SweetSansPro-Heavy", "TechnoRegular", "Telex-Regular", "Textile", "TiffanyStd-Demi", "TiffanyStd-Heavy", "TimesNewRomanMTStd", "TradeGothicLTStd", "TrajanPro-Regular", "TriniteNo1-Bold", "Triplex-Bold", "TriplexSerif-Bold", "Trixie-Text", "Tungsten-Medium", "Ubuntu", "UbuntuMono-Bold", "Unispace", "UniversityRomanStd", "UniversLTStd", "UtopiaStd-Regular", "VAGRoundedStd-Bold", "VendomeICG", "Verdana", "Verlag-Book", "Verve", "Vitesse-Book", "Vitesse-Medium", "Whitney-Light", "WilhelmKlingsporGotLTStd", "WindsorBT-Roman", "Zapfino"
]

using Luxor, Colors

function editfontname(ff1)
    ff2 = replace(ff1, "Std", "")
    ff2 = replace(ff2, "-", " ")
    ff2 = replace(ff2, r"MT|LT|TT", "")
    ff2 = replace(ff2, "Bd", "Bold")
    ff2 = replace(ff2, "Bk", "Book")
    ff2 = replace(ff2, r"([A-z])(Pro)", s"\1 \2")
    ff2 = replace(ff2, "Regular", "")
    return ff2
end

function heart()
    move(127,1) # bother, it's offset from 0/0
    curve(134.2, -6.5, 134.2, -6.5, 156.1, -29.6)
    curve(185.8, -60.5, 198.1, -74.3, 213.7, -95.3)
    curve(240.4, -131, 253.3, -163.7, 253.3, -194.9)
    curve(253.3, -218, 246.4, -237.8, 232.6, -253.7)
    curve(219.1, -268.7, 204.1, -275.3, 181.9, -275.3)
    curve(154, -275.3, 136.3, -265.1, 127, -243.8)
    curve(124, -252.5, 120.4, -257.6, 112.9, -263.6)
    curve(103.6, -270.8, 88.3, -275.3, 73.3, -275.3)
    curve(59.2, -275.3, 46, -271.4, 35.2, -264.5)
    curve(14.5, -250.7, 1, -223.4, 1, -194.6)
    curve(1, -167.3, 13, -136.4, 37.3, -101)
    curve(53.8, -77, 86.5, -39.8, 127, 1)
    closepath()
end

function placefonts(fontlist, str, background="white")
    global x, y, xstep, ystep, hmargin, vmargin, rowspacing, oversizefonts
    for font in fontlist
        fontface(font)
        # work out size at which every letter is the same height
        fsize = 50
        te = []
        while true
            fontsize(fsize)
            te = textextents(str) # [xb, yb, width, height, xadvance, yadvance]
            if te[3] == 0 break end # some fonts don't  have certain characters...
            if te[4] > ystep
                break
            else
                fsize += 1
            end
        end
        # draw character at the size we found
        fontsize(fsize)
        textcentered(str, x, y)
        # underneath, draw its name
        fontface("BellCentennialStd-Address")
        fontsize(6)
        fontnamemodified = editfontname(font)
        # in case glyph overlaps with text, put a semitransparent box behind the text (yuk)
        gsave()
        sethue(background)
        setopacity(0.5)
        te = textextents(fontnamemodified)
        rect(x - te[3]/2 - te[1], y + te[4], te[3] + te[1], -te[4] - te[2] + 12, :fill)
        grestore()
        # show font name
        textcentered(fontnamemodified, x, y + 12)
        # room for another one?
        nextxpos = x + te[3]/2 + xstep
        if nextxpos > (pagewidth - hmargin - xstep - xstep)
            x = hmargin
            y += ystep + rowspacing
        else
            x += xstep + rowspacing
        end
    end
end

const pagewidth = 1190 # A2 size paper, points
const pageheight = 1684 # A2 size paper, points

function main(str)
    global x, y, xstep, ystep, hmargin, vmargin, rowspacing, oversizefonts
    filename = replace("i-love-" * str * "-fonts.pdf", r"[^A-z0-9.]", "")
    Drawing(pagewidth, pageheight, "/tmp/$(filename)")
    # background and title
    background = "mintcream"
    sethue(background)
    rect(0,0, pagewidth, pageheight, :fill)
    sethue(0,0,0)
    fontface("Perla")
    fontsize(60)
    text("I ", (pagewidth/2) - 295, 115)
    text(" ampersands!", (pagewidth/2) - 210, 115)
    gsave()
    translate((pagewidth/2) - 255, 115)
    scale(.175, .175)
    heart()
    sethue("red")
    fillstroke()
    grestore()

    sethue(0,0,0)
    gsave()
    translate(70,200) # start below top, point size is up

    # row is y, increasing down from the top
    # col is x, increasing right from the left

    xstep     = 60
    ystep     = 46
    hmargin   = 20
    vmargin   = 20
    x         = hmargin
    y         = vmargin
    rowspacing = 30 # horizontal column gap
    placefonts(fontslist, str, background)
    grestore()
    # decoration at the bottom
    gsave()
    translate(pagewidth/2, pageheight - vmargin - 12)
    setline(0.2)
    x_vals = -14 * 2 * pi:pi/200: 14 * 2 * pi
    pl = [Point(d * 2 * pi , -sin(d) * cos(12 * d) * 8 * sin(d/10)) for d in x_vals]
    poly(simplify(pl, 0.05), close=false, :stroke)
    grestore()
    # border decoration around the edges
    setline(1.6)
    translate((pagewidth/2),(pageheight/2))
    rect(-(pagewidth/2) + 6, -(pageheight/2) + 6, pagewidth - 12, pageheight - 12, :stroke)
    setline(.5)
    rect(-(pagewidth/2) + 10, -(pageheight/2) + 10, pagewidth - 20, pageheight - 20, :stroke)
    finish()
    preview()
end

main("&")
