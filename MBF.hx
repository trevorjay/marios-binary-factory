package;

import rom.ROM;
import sys.io.File;
import sys.io.FileInput;

class MBF extends ROM {
  var env:Map<String,Int>;

  public function new(raw:String,romName:String) {
    super(romName);
    var out = Sys.stdout();
    out.writeString('Creating ${romName}.\n');

    out.writeString("Initializing environment.\n");
    env = new Map<String,Int>();

    out.writeString("Stripping comments.\n");
    var wComments = raw.toLowerCase().split('\n');
    var woComments:Array<String> = [];
    for (line in wComments) woComments.push(line.split(";")[0]);

    out.writeString("Splitting columns.\n");
    var asm:Array<Array<String>> = [];
    var ws = ~/[ \t]+/g;
    for (line in woComments) asm.push(ws.split(line));

    out.writeString("Beginning first parsing pass.\n");
    out.writeString("Processing line ");
    var lineNo = 1;
    for (line in asm) {
      processLine(line);
      out.writeString(' ${lineNo++} ');
      out.flush();
    }
    out.writeString(".\n");

    out.writeString("Resetting rom.\n");
    rom.fill(0,4096,0);

    out.writeString("Beginning second parsing pass.\n");
    out.writeString("Processing line ");
    lineNo = 1;
    for (line in asm) {
      processLine(line);
      out.writeString(' ${lineNo++} ');
      out.flush();
    }
    out.writeString(".\n");

    out.writeString("Finalizing rom.\n");
    end();
    out.close();
  }

  function processLine(line:Array<String>):Void {
    if (line.length == 1 && line[0] == "") return;

    if (line.length >= 2 && line[0] == "org") {
      addr = num(line[1]);
      return;
    }

    if (line.length == 3 && line[1] == "equ") {
      env[line[0]] = num(line[2]);
      return;
    }

    if (line.length == 3 && line[1] == ".word") {
      rom.set(addr,num(line[2]));
      incAddr();
      return;
    }

    if (line[0] != "") {
      env[line[0]] = addr;
      return;
    }

    if (line.length < 2) return;

    var operand = 0;
    if (line.length == 3) operand = num(line[2]);

    var opcode = line[1];

    switch opcode {
      case "add": add();
      case "add11": add11();
      case "atbp": atbp();
      case "atfc": atfc();
      case "atl": atl();
      case "atpl": atpl();
      case "atr": atr();
      case "bdc": bdc();
      case "cend": cend();
      case "coma": coma();
      case "dc": dc();
      case "decb": decb();
      case "exbla": exbla();
      case "idiv": idiv();
      case "incb": incb();
      case "kta": kta();
      case "rc": rc();
      case "rot": rot();
      case "rtn0": rtn0();
      case "rtn1": rtn1();
      case "sbm": sbm();
      case "sc": sc();
      case "ta0": ta0();
      case "tabl": tabl();
      case "tal": tal();
      case "tam": tam();
      case "tb": tb();
      case "tc": tc();
      case "tf1": tf1();
      case "tf4": tf4();
      case "tis": tis();
      case "wr": wr();
      case "ws": ws();
      case "adx": adx(operand);
      case "exc": exc(operand);
      case "excd": excd(operand);
      case "exci": exci(operand);
      case "lax": lax(operand);
      case "lb": lb(operand);
      case "lda": lda(operand);
      case "rm": rm(operand);
      case "sm": sm(operand);
      case "t": t(operand);
      case "tm": tm(operand);
      case "tmi": tmi(operand);
      case "lbl": lbl(operand);
      case "tl": tl(operand);
      case "tml": tml(operand);
      default: skip();
    }

  }

  function num(str:String):Int {
    var val = 0;
    if (str.charAt(0) != "$") {
      val = env[str];
      if (val != null) return val;
      return 0;
    }

    str = str.split("$")[1];
    var val = 0;
    for (i in 0...str.length) val = val*16 + ((str.charCodeAt(i) >= 97) ? str.charCodeAt(i)-97+10 : str.charCodeAt(i)-48);
    return val;
  }

  public static function main() {
    if (Sys.args().length != 2) {
      var out = Sys.stdout();
      out.writeString("needed arguments:\n    input.asm output.bin        #assemble .asm into .bin\n");
      out.close();
      Sys.exit(1);
    }

    try {
      var asm = File.read(Sys.args()[0]).readAll().toString();
      var mbf = new MBF(asm,Sys.args()[1]);
    } catch (e:Dynamic) {
      var err = Sys.stderr();
      try {
        var msg = cast(e, String);
        err.writeString('Error:\n    ${msg}\n');
      } catch (e:Dynamic) {
        err.writeString('Unknown error.\n');
      }
      err.close();
      Sys.exit(1);
    }

    Sys.exit(0);

  }
}
