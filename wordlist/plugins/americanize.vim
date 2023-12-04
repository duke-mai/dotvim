" -our to -or
"  e.g. colour -> color
"  suffixes: color, colors, colored, colorless, colorist, honorable
%Subvert/{col,behavi,fav,flav,hon,lab,neighb,rum,vap,rum}our{,s,ed,less,able,ing}/{}or{}/g

" -re to -er
"  e.g. litre -> liter
"  suffixes: liter, liters
%Subvert/\b{cent,met,kilomet,lit,lust,mit,nit,goit,reconnoit,saltpet,spect,theat,tit}re{,s}/{}er{}/g

" -ce to -se
"  e.g. defence -> defense
%Subvert/{defen,offen,preten}ce/{}se/g

" Doubled consonants before a suffix
%Subvert/jewellery/jewelry/g
%Subvert/{fulfil}{,s}/{}l{}/g
%Subvert/{cancel,fuel,travel}l{ed,ing}/{}{}/g

" Dropped 'e'
" british: likeable
" american: likable
%Subvert/{lik,liv,rat,sal,siz,unshak}eable/{}able/g
%Subvert/judgement/judgment/g

" organize, organized, organization and similar...
%Subvert/{actual,aggrand,agon,alphabet,antagon,anthropomorph,aphor,apolog,arbor,author,autom,bapt,barbar,brutal,canon,capital,categor,cauter,character,civil,colon,color,compartmental,computer,conceptual,concret,criminal,critic,crystal,custom,demonet,departmental,desensit,destabil,digital,digit,dogmat,dramat,econom,emphas,energ,equal,eulog,euthan,extempor,external,factual,fantas,fertil,fibern,final,formal,fratern,galvan,general,global,harmon,hellen,homogen,hospital,human,hypnot,hypothes,ideal,immobil,individual,institutional,internal,ion,legal,legitim,lion,material,maxim,memor,mesmer,method,minim,mobil,moral,motor,national,natural,neutral,normal,notar,optim,organ,ostrac,pagan,pasteur,patron,penal,personal,philosoph,plagiar,polar,popular,pressur,priorit,privat,proselyt,public,pulver,quant,random,rational,real,recogn,regional,revital,satir,sensual,serial,social,special,stabil,standard,steril,stigmat,subsid,summar,symbol,synchron,synthes,terror,theor,total,tranquil,trivial,tyrann,universal,urban,util,vandal,vapor,vasectom,visual,vocal,weather,woman}is{e,ed,er,es,ation,ing}/{}iz{}/g

" analyse, analysed and similar...
%Subvert/{anal,cata,hydrol,paral}ys{e,ed}/{}yz{}/g

" AE and OE simplifications
%Subvert/amoeba/ameba/g
%Subvert/anaemia/anemia/g
%Subvert/anaesthe{sia,tic,siologist}/anesthe{}/g
%Subvert/anaesthetist/anesthesiologist/g
%Subvert/caesium/cesium/g
%Subvert/diarrhoea/diarrhea/g
%Subvert/encyclopaedi{a,c}/encyclopedi{}/g
%Subvert/faeces/feces/g
%Subvert/\bfoet{al,us}/fet{}/g
%Subvert/gynaecolog{y,ist}/gynecolog{}/g
%Subvert/haemophilia/hemophilia/g
%Subvert/leukaemia/leukemia/g
%Subvert/oesophagus/esophagus/g
%Subvert/oestrogen/estrogen/g
%Subvert/orthopaedic/orthopedic/g
%Subvert/palaeontolog{y,ist}/paleontology{}/g
%Subvert/paediatric/pediatric/g
%Subvert/homoeopath{y,ic}/homeopath{}/g
%Subvert/mediaeval/medieval/g
%Subvert/manoeuv{re,res,red}/maneuv{er,ers,ered}/g

" Miscellaneous
%Subvert/cheque{,s,r,rs}/check{,s,er,ers}/g
%Subvert/chilli/chili/g
" %Subvert/draught{,y,ed}/draft{,y,ed}/g
%Subvert/kerb/curb/g
%Subvert/liquorice/licorice/g
%Subvert/minced{ meat, pork, beef}/ground{ meat, pork, pork}/g
%Subvert/mould{,y}/mold{,y}/g
%Subvert/moult{,y}/molt{,y}/g
%Subvert/moustache/mustach/g
%Subvert/phoney/phony/g
%Subvert/pyjamas/pajamas/g
%Subvert/plough{,man}/plow{,man}/g
%Subvert/sceptic{,al,ism}/skeptic{,al,ism}/g
%Subvert/spring onion/green onion/g
%Subvert/\btin/can/g
%Subvert/\btyre{,s}/tire{,s}/g
%Subvert/washbasin/washbowl/g
