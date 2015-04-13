<%--
  Created by IntelliJ IDEA.
  User: anbu02
  Date: 15.10.14
  Time: 10:08
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="layouts._topbar.help"/></title>
    <meta name="layout" content="main" />
</head>

<body>
<div class="help"><%--<g:message code="configuration.help.configuration"/>--%>

Kurzanleitung EmobilSim<br><br>
1.	Registrierung/Einloggen. Nach der Registrierung wird eine Bestätigungs-Email versandt. Danach kann der Benutzer sich mit seiner Emailadresse einloggen.
    <br><br>
    <g:img class="simula" file="simulation/1.png"/><br><br>
2.	Nach dem erfolgreichem Registrierung, ist es möglich die Simulation zu nutzen. Es gibt schon vorkonfigurierte Simulationen oder es ist möglich selbst neue Simulation zu erstellen. Derzeit sehen alle Benutzer alle Simulationsdaten im System!
    <br><br>
    <g:img class="simula" file="simulation/2.png"/>
    <br><br>
3.	Konfigurieren einer neuen Simulation Momentan existieren zwei Simulationsgebiete: Berlin und Wiesloch. Berlin wird als Default eingestellt.
    Die Konfiguration besteht aus zwei Teilen: Konfiguration von Fahrzeugflotten und Konfiguration von Ladestationen.
    In der Liste „Verfügbare Fahrzeugflotten“ gibt schon konfigurierte Flotten.
    <br><br>
    <g:img class="simula" file="simulation/3.png"/>
    <br><br>
4.	Erstellen neue Fahrzeugflotte. Es ist möglich unterschiedliche Elektroautos zur Flotte hinzufügen. Wenn Sie neue Autotypen einfügen wollen, die nicht in der Liste ist, dann müssen Sie in Menu/Extras den neuen Autotyp definieren.
    <br><br>
    <g:img class="simula" file="simulation/4.png"/>
    <br><br>
5.	Erstellen neue Autotyp. In Extras sind alle populären Elektroautos dargestellt. Beim  Anklickt „Neue Fahrzeugtyp erstellen“ wird  neue Autotyp erstellt.
    <br><br>
    <g:img class="simula" file="simulation/5.png"/>
    <br><br>
6.	Flotte konfigurieren. Nach dem Erstellen einer neuen Flotte müssen Routen für diese Flotte ausgewählt werden. Klick „Auswählen“. Die Flotte wird dann zu der Simulation eingefügt. Jetzt müssen die Routen festgelegt werden.
Die Routen können entweder gezeichnet werden müssen auf die Karte, oder beim Klick auf den Tab „Zufällige Routen festlegen“ bestimmte Kilometerzahl eingeben. Die Routen werden randomisiert berechnet und eingetragen.
    <br><br>
    <g:img class="simula" file="simulation/6.png"/>
    <br><br>
Für das Zeichen muss man das „Auto“-Icon rechts oben   anklicken. Es ist möglich eine Route pro Auto zeichnen. Nach dem Schließen der Seite sind die Routen konfiguriert.
    <br><br>
    <g:img class="simula" file="simulation/7.png"/>
    <br><br>
    <g:img class="simula" file="simulation/8.png"/>
    <br><br>
7.	Ladestationen konfigurieren. Die Ladestationen können genauso wie Autos erstellt und konfiguriert werden. Es ist möglich neue Ladestationstypen zu erstellen und in der Simulation einzufügen.
    <br><br>
8.	Simulation durchführen. Wenn Flotten und Ladestationen voll konfiguriert sind, sieht die Simulationsseite folgendermaßen aus.
    <br><br>
    <g:img class="simula" file="simulation/9.png"/>
    <br><br>
9.	Beim Klick „Durchführen“ wird die Simulation berechnet. Dies kann einige Zeit dauern!  Am Ende wird dann die nächste Sicht angezeigt, die den Simulationsablauf darstellt.
    <br><br>
10.	Im nächsten Schritt ist es möglich die Simulation abspielen.  Oben  wird der Simulationsablauf für jedes Auto dargestellt. Jedes Auto hat zwei Balken: Gefahrene Kilometer (ocker)  und Akkuzustand (grau). Im grauen Querbalken sind die Typen der einzelnen Autis angezeigt. Balke wird die Autos, die in der Simulation teilnehmen anzeigen. Die letzte Balke stellt alle Ladestationen dar. Wenn Die Ladestation besetzt ist, wird Sie rot markiert.
    <br><br>
    <g:img class="simula" file="simulation/10.png"/>
    <br><br>
11.	Auswertung  Der Button „Statistische Daten“ bietet unterschiedliche statistische Daten über die Simulation. Die Daten sind nach Flotten und Ladestationgruppen eingruppiert.
    <br><br>
    <g:img class="simula" file="simulation/11.png"/>
    <br><br>
12.	Es ist möglich bestimmte Bereich als Plot Diagramm darzu stellen.
    <br><br>
    <g:img class="simula" file="simulation/12.png"/>
    <br><br>

13.	Ladestationen bieten ähnliches Darstellung. Es ist möglich auch zu sehen welche von Ladestationen wurden während der Simulation benutzt und wie viel Zeit.
    <br><br>
    <g:img class="simula" file="simulation/13.png"/>
    <br><br>
    <br><br>
    <g:img class="simula" file="simulation/14.png"/>
    <br><br>
    <br><br>
    <g:img class="simula" file="simulation/15.png"/>
    <br><br>
    <br><br>
    <g:img class="simula" file="simulation/16.png"/>
    <br><br>
</div>
</body>
</html>