package rom;

import haxe.io.Bytes;
import sys.io.File;

typedef Pointer = {
  pu: Int,
  pm: Int,
  pl: Int
}

class ROM {
  var steps:Array<Int> = [0,32,48,56,60,62,31,47,55,59,61,30,15,39,51,57,28,46,23,43,53,26,13,6,3,33,16,40,52,58,29,14,7,35,49,24,44,54,27,45,22,11,37,18,9,4,34,17,8,36,50,25,12,38,19,41,20,42,21,10,5,2,1];
  var pageSize:Int = 64;
  var pages:Array<Int> = [
    0,1,2,3,4,5,6,7,8,9,10,
    16,17,18,19,20,21,22,23,24,25,26,
    32,33,34,35,36,37,38,39,40,41,42,
    48,49,50,51,52,53,54,55,56,57,58
  ];
  var pageSetSize:Int = 11;
  var rom:Bytes;
  var addr:Int;
  var filename:String;

  public function new(name:String) {
    filename = name;
    rom = Bytes.alloc(4096); //4k ROM
    addr = 0;
  }

  function pointerAt(a:Int):Pointer {
    var page:Int = Math.floor(a/pageSize);
    var pageIdx:Int = pages.indexOf(page);
    var pageSet:Int = Math.floor(pageIdx/pageSetSize); 
    var step:Int = (a-page*pageSize);
    var stepIdx:Int = steps.indexOf(step);
    return {pu: pageSet, pm: pageIdx-(pageSet*pageSetSize), pl: step};
  }

  function incAddr():Int {
    var ptr = pointerAt(addr);
    var step = steps.indexOf(ptr.pl);
    step = (step + 1) % steps.length;
    var page = ptr.pu*pageSetSize+ptr.pm;
    if (step == 0) {
      page = (page + 1) % pages.length;
    }
    addr = pages[page]*pageSize+steps[step];
    return addr;
  }

  function end():Void {
    File.saveBytes(filename,rom);
  }

  function op_add():Array<Int> {return [0x08];}
  function op_add11():Array<Int> {return [0x9];}
  function op_atbp():Array<Int> {return [0x01];}
  function op_atfc():Array<Int> {return [0x60];}
  function op_atl():Array<Int> {return [0x59];}
  function op_atpl():Array<Int> {return [0x03];}
  function op_atr():Array<Int> {return [0x61];}
  function op_bdc():Array<Int> {return [0x6D];}
  function op_cend():Array<Int> {return [0x5D];}
  function op_coma():Array<Int> {return [0x0A];}
  function op_dc():Array<Int> {return [0x3A];}
  function op_decb():Array<Int> {return [0x6C];}
  function op_exbla():Array<Int> {return [0x0B];}
  function op_idiv():Array<Int> {return [0x65];}
  function op_incb():Array<Int> {return [0x64];}
  function op_kta():Array<Int> {return [0x6A];}
  function op_rc():Array<Int> {return [0x66];}
  function op_rot():Array<Int> {return [0x6B];}
  function op_rtn0():Array<Int> {return [0x6E];}
  function op_rtn1():Array<Int> {return [0x6F];}
  function op_sbm():Array<Int> {return [0x02];}
  function op_sc():Array<Int> {return [0x67];}
  function op_skip():Array<Int> {return [0x00];}
  function op_ta0():Array<Int> {return [0x5A];}
  function op_tabl():Array<Int> {return [0x5B];}
  function op_tal():Array<Int> {return [0x5E];}
  function op_tam():Array<Int> {return [0x53];}
  function op_tb():Array<Int> {return [0x51];}
  function op_tc():Array<Int> {return [0x52];}
  function op_tf1():Array<Int> {return [0x68];}
  function op_tf4():Array<Int> {return [0x69];}
  function op_tis():Array<Int> {return [0x58];}
  function op_wr():Array<Int> {return [0x62];}
  function op_ws():Array<Int> {return [0x63];}

  function op_adx(x:Int):Array<Int> {return [0x30 | x];}
  function op_exc(x:Int):Array<Int> {return [0x10 | (x & 3)];}
  function op_excd(x:Int):Array<Int> {return [0x1C+x];}
  function op_exci(x:Int):Array<Int> {return [0x14+x];}
  function op_lax(x:Int):Array<Int> {return [0x20 | x];}
  function op_lb(x:Int):Array<Int> {return [0x40 | x];}
  function op_lda(x:Int):Array<Int> {return [0x18+x];}
  function op_rm(x:Int):Array<Int> {return [0x04+x];} 
  function op_sm(x:Int):Array<Int> {return [0x0C+x];} 
  function op_t(x:Int):Array<Int> {return [0x80 | x];}
  function op_tm(x:Int):Array<Int> {return [0xC0+x];}
  function op_tmi(x:Int):Array<Int> {return [0x54+x];}

  function op_lbl(xy:Int):Array<Int> {return [0x5F,xy];}
  function op_tl(x:Int,yz:Int):Array<Int> {return [0x70|x,yz];}
  function op_tml(x:Int,yz:Int):Array<Int> {return [0x7C|x,yz];}

  function add():Void {rom.set(addr,op_add()[0]); incAddr();}
  function add11():Void {rom.set(addr,op_add11()[0]); incAddr();}
  function atbp():Void {rom.set(addr,op_atbp()[0]); incAddr();}
  function atfc():Void {rom.set(addr,op_atfc()[0]); incAddr();}
  function atl():Void {rom.set(addr,op_atl()[0]); incAddr();}
  function atpl():Void {rom.set(addr,op_atpl()[0]); incAddr();}
  function atr():Void {rom.set(addr,op_atr()[0]); incAddr();}
  function bdc():Void {rom.set(addr,op_bdc()[0]); incAddr();}
  function cend():Void {rom.set(addr,op_cend()[0]); incAddr();}
  function coma():Void {rom.set(addr,op_coma()[0]); incAddr();}
  function dc():Void {rom.set(addr,op_dc()[0]); incAddr();}
  function decb():Void {rom.set(addr,op_decb()[0]); incAddr();}
  function exbla():Void {rom.set(addr,op_exbla()[0]); incAddr();}
  function idiv():Void {rom.set(addr,op_idiv()[0]); incAddr();}
  function incb():Void {rom.set(addr,op_incb()[0]); incAddr();}
  function kta():Void {rom.set(addr,op_kta()[0]); incAddr();}
  function rc():Void {rom.set(addr,op_rc()[0]); incAddr();}
  function rot():Void {rom.set(addr,op_rot()[0]); incAddr();}
  function rtn0():Void {rom.set(addr,op_rtn0()[0]); incAddr();}
  function rtn1():Void {rom.set(addr,op_rtn1()[0]); incAddr();}
  function sbm():Void {rom.set(addr,op_sbm()[0]); incAddr();}
  function sc():Void {rom.set(addr,op_sc()[0]); incAddr();}
  function skip():Void {rom.set(addr,op_skip()[0]); incAddr();}
  function ta0():Void {rom.set(addr,op_ta0()[0]); incAddr();}
  function tabl():Void {rom.set(addr,op_tabl()[0]); incAddr();}
  function tal():Void {rom.set(addr,op_tal()[0]); incAddr();}
  function tam():Void {rom.set(addr,op_tam()[0]); incAddr();}
  function tb():Void {rom.set(addr,op_tb()[0]); incAddr();}
  function tc():Void {rom.set(addr,op_tc()[0]); incAddr();}
  function tf1():Void {rom.set(addr,op_tf1()[0]); incAddr();}
  function tf4():Void {rom.set(addr,op_tf4()[0]); incAddr();}
  function tis():Void {rom.set(addr,op_tis()[0]); incAddr();}
  function wr():Void {rom.set(addr,op_wr()[0]); incAddr();}
  function ws():Void {rom.set(addr,op_ws()[0]); incAddr();}

  function adx(x:Int):Void {rom.set(addr,op_adx(x)[0]); incAddr();}
  function exc(x:Int):Void {rom.set(addr,op_exc(x)[0]); incAddr();}
  function excd(x:Int):Void {rom.set(addr,op_excd(x)[0]); incAddr();}
  function exci(x:Int):Void {rom.set(addr,op_exci(x)[0]); incAddr();}
  function lax(x:Int):Void {rom.set(addr,op_lax(x)[0]); incAddr();}
  function lb(x:Int):Void {rom.set(addr,op_lb(x)[0]); incAddr();}
  function lda(x:Int):Void {rom.set(addr,op_lda(x)[0]); incAddr();}
  function rm(x:Int):Void {rom.set(addr,op_rm(x)[0]); incAddr();}
  function sm(x:Int):Void {rom.set(addr,op_sm(x)[0]); incAddr();}
  function tm(x:Int):Void {rom.set(addr,op_tm(x)[0]); incAddr();}
  function tmi(x:Int):Void {rom.set(addr,op_tmi(x)[0]); incAddr();}

  function lbl(xy:Int):Void {
    var ops = op_lbl(xy);
    rom.set(addr,ops[0]);
    incAddr();
    rom.set(addr,ops[1]);
    incAddr();
  }

  function t(a:Int):Void {
    var ptr = pointerAt(a);
    rom.set(addr,op_t(ptr.pl)[0]);
    incAddr();
  }

  function tl(a:Int):Void {
    var ptr = pointerAt(a);
    var ops = op_tl(ptr.pm,ptr.pu << 6 | ptr.pl);
    rom.set(addr,ops[0]);
    incAddr();
    rom.set(addr,ops[1]);
    incAddr();
  }

  function tml(a:Int):Void {
    var ptr = pointerAt(a);
    var ops = op_tml(ptr.pm,ptr.pu << 6 | ptr.pl);
    rom.set(addr,ops[0]);
    incAddr();
    rom.set(addr,ops[1]);
    incAddr();
  }
}
