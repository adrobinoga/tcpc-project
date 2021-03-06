/* Generated by Yosys 0.7 (git sha1 61f6811, gcc 5.4.0-6ubuntu1~16.04.4 -O2 -fstack-protector-strong -fPIC -Os) */

module rx(clk, hard_reset, cable_reset, tx_state_machine_active, DataBusIn, MESSAGE_HEADER_INFO_IN, RECEIVE_DETECT_IN, TX_BUF_HEADER_BYTE_1, TX_BUF_HEADER_BYTE_0, RX_BUF_HEADER_BYTE_1, RX_BUF_HEADER_BYTE_0, GoodCRC_Message_Discarded, GoodCRC_Transmission_Complete, rx_goodcrc, rx_tx_message_discard, DirBus, DataBusOut, memory_request, RNW, idle, RECEIVE_BYTE_COUNT_OUT, ALERT_Register, RX_BUF_FRAME_TYPE, RECEIVE_DETECT_OUT);
  wire [3:0] _000_;
  wire [3:0] _001_;
  wire [3:0] _002_;
  wire _003_;
  wire [1:0] _004_;
  wire [1:0] _005_;
  wire [1:0] _006_;
  wire [1:0] _007_;
  wire [1:0] _008_;
  wire [1:0] _009_;
  wire [1:0] _010_;
  wire [1:0] _011_;
  wire [1:0] _012_;
  wire _013_;
  wire [1:0] _014_;
  wire [1:0] _015_;
  wire [1:0] _016_;
  wire [1:0] _017_;
  wire [1:0] _018_;
  wire [1:0] _019_;
  wire [1:0] _020_;
  wire [2:0] _021_;
  wire [2:0] _022_;
  wire _023_;
  wire [2:0] _024_;
  wire _025_;
  wire [1:0] _026_;
  wire [1:0] _027_;
  wire [1:0] _028_;
  wire [1:0] _029_;
  wire [1:0] _030_;
  wire _031_;
  wire [3:0] _032_;
  wire [3:0] _033_;
  wire [3:0] _034_;
  wire [3:0] _035_;
  wire [3:0] _036_;
  wire [3:0] _037_;
  wire [3:0] _038_;
  wire _039_;
  wire _040_;
  wire _041_;
  wire _042_;
  wire _043_;
  wire _044_;
  wire _045_;
  wire _046_;
  wire _047_;
  wire _048_;
  wire _049_;
  wire _050_;
  wire _051_;
  wire _052_;
  wire _053_;
  wire _054_;
  wire _055_;
  wire _056_;
  wire _057_;
  wire _058_;
  wire _059_;
  wire [31:0] _060_;
  wire [7:0] _061_;
  wire [7:0] _062_;
  wire [15:0] _063_;
  wire [7:0] _064_;
  wire [7:0] _065_;
  wire [7:0] _066_;
  wire [15:0] _067_;
  wire [3:0] _068_;
  wire [3:0] _069_;
  wire [3:0] _070_;
  wire [3:0] _071_;
  wire [3:0] _072_;
  wire _073_;
  wire [3:0] _074_;
  wire _075_;
  wire _076_;
  output [7:0] ALERT_Register;
  input [7:0] DataBusIn;
  output [7:0] DataBusOut;
  output [7:0] DirBus;
  input GoodCRC_Message_Discarded;
  input GoodCRC_Transmission_Complete;
  input [7:0] MESSAGE_HEADER_INFO_IN;
  wire MessageRecivedFromPHY;
  wire MessageType;
  output [7:0] RECEIVE_BYTE_COUNT_OUT;
  input [7:0] RECEIVE_DETECT_IN;
  output [7:0] RECEIVE_DETECT_OUT;
  output RNW;
  output [7:0] RX_BUF_FRAME_TYPE;
  input [7:0] RX_BUF_HEADER_BYTE_0;
  input [7:0] RX_BUF_HEADER_BYTE_1;
  wire RxBufferFull;
  input [7:0] TX_BUF_HEADER_BYTE_0;
  input [7:0] TX_BUF_HEADER_BYTE_1;
  wire [3:0] WriteGoodCRC_counter;
  input cable_reset;
  input clk;
  input hard_reset;
  output idle;
  output memory_request;
  wire [3:0] nextState;
  input rx_goodcrc;
  output rx_tx_message_discard;
  wire [3:0] state;
  input tx_state_machine_active;
  assign _004_[1] = state[2] | _032_[3];
  assign _039_ = _004_[0] | _004_[1];
  assign _005_[0] = _033_[0] | RX_BUF_HEADER_BYTE_0[1];
  assign _005_[1] = RX_BUF_HEADER_BYTE_0[2] | RX_BUF_HEADER_BYTE_0[3];
  assign _040_ = _005_[0] | _005_[1];
  assign _041_ = _006_[0] | _006_[1];
  assign _004_[0] = state[0] | state[1];
  assign _007_[1] = _035_[2] | state[3];
  assign _042_ = _004_[0] | _007_[1];
  assign _008_[0] = state[0] | _036_[1];
  assign _043_ = _008_[0] | _008_[1];
  assign _006_[1] = _034_[2] | WriteGoodCRC_counter[3];
  assign _044_ = _009_[0] | _006_[1];
  assign _010_[0] = WriteGoodCRC_counter[0] | _037_[1];
  assign _045_ = _010_[0] | _010_[1];
  assign _006_[0] = _002_[0] | WriteGoodCRC_counter[1];
  assign _046_ = _006_[0] | _010_[1];
  assign _011_[0] = _002_[0] | _037_[1];
  assign _010_[1] = WriteGoodCRC_counter[2] | WriteGoodCRC_counter[3];
  assign _047_ = _011_[0] | _010_[1];
  assign _012_[0] = _038_[0] | state[1];
  assign _008_[1] = state[2] | state[3];
  assign _048_ = _012_[0] | _008_[1];
  assign _013_ = _059_ | _058_;
  assign _003_ = _013_ | _050_;
  assign _061_[2] = _017_[0] | _017_[1];
  assign _061_[1] = _018_[0] | _018_[1];
  assign _019_[1] = _060_[16] | _060_[24];
  assign _061_[0] = _018_[0] | _019_[1];
  assign _020_[0] = _017_[0] | _018_[0];
  assign _075_ = _020_[0] | _020_[1];
  assign _065_[6] = _018_[0] | _020_[1];
  assign _022_[0] = _024_[0] | _017_[0];
  assign _022_[1] = _021_[1] | _018_[0];
  assign _023_ = _022_[0] | _022_[1];
  assign _065_[4] = _023_ | _020_[1];
  assign _020_[1] = _060_[16] | _024_[2];
  assign _025_ = _024_[0] | _022_[1];
  assign _065_[0] = _025_ | _024_[2];
  assign _064_[5] = _058_ | _063_[13];
  assign _064_[1] = _058_ | _063_[9];
  assign _064_[0] = _058_ | _063_[8];
  assign _026_[1] = _067_[10] | _067_[14];
  assign _068_[2] = _026_[0] | _026_[1];
  assign _027_[1] = _067_[11] | _067_[15];
  assign _068_[3] = _027_[0] | _027_[1];
  assign _068_[1] = _028_[0] | _028_[1];
  assign _029_[0] = _058_ | _067_[4];
  assign _029_[1] = _067_[8] | _067_[12];
  assign _068_[0] = _029_[0] | _029_[1];
  assign memory_request = _058_ | _050_;
  assign _030_[1] = _059_ | _073_;
  assign _076_ = memory_request | _030_[1];
  assign _009_[0] = WriteGoodCRC_counter[0] | WriteGoodCRC_counter[1];
  assign _031_ = _009_[0] | _010_[1];
  assign _050_ = ~_039_;
  assign _024_[0] = ~_041_;
  assign _058_ = ~_042_;
  assign _059_ = ~_043_;
  assign _017_[0] = ~_044_;
  assign _018_[0] = ~_045_;
  assign _060_[16] = ~_046_;
  assign _024_[2] = ~_031_;
  assign _021_[1] = ~_047_;
  assign _073_ = ~_048_;
  assign _052_ = hard_reset | cable_reset;
  assign _053_ = _054_ | MessageRecivedFromPHY;
  assign _051_ = GoodCRC_Message_Discarded | GoodCRC_Transmission_Complete;
  assign RNW = ~_003_;
  assign DataBusOut[0] = _039_ ? 1'b0 : _062_[0];
  assign DataBusOut[1] = _039_ ? 1'b0 : _062_[1];
  assign DataBusOut[2] = _039_ ? 1'b0 : _062_[2];
  assign DataBusOut[3] = _039_ ? 1'b0 : _062_[3];
  assign DataBusOut[6] = _039_ ? 1'b0 : _062_[6];
  assign DataBusOut[7] = _039_ ? 1'b0 : _062_[7];
  assign _069_[0] = _051_ ? 1'b0 : state[0];
  assign _069_[1] = _051_ ? 1'b0 : state[1];
  assign _069_[2] = _051_ ? 1'b1 : state[2];
  assign _069_[3] = _051_ ? 1'b0 : state[3];
  assign _070_[0] = _041_ ? state[0] : _069_[0];
  assign _070_[1] = _041_ ? state[1] : _069_[1];
  assign _070_[2] = _041_ ? state[2] : _069_[2];
  assign _070_[3] = _041_ ? state[3] : _069_[3];
  assign _049_ = ~_040_;
  assign _071_[0] = ~rx_goodcrc;
  assign _071_[2] = rx_goodcrc ? _049_ : 1'b0;
  assign _071_[3] = rx_goodcrc ? _040_ : 1'b0;
  assign _072_[0] = _053_ ? 1'b0 : state[0];
  assign _072_[1] = _053_ ? 1'b1 : state[1];
  assign _072_[2] = _053_ ? 1'b0 : state[2];
  assign _072_[3] = _053_ ? 1'b0 : state[3];
  assign _000_[0] = _039_ ? 1'b0 : _002_[0];
  assign _000_[1] = _039_ ? 1'b0 : _002_[1];
  assign _000_[2] = _039_ ? 1'b0 : _002_[2];
  assign _000_[3] = _039_ ? 1'b0 : _002_[3];
  assign _001_[0] = _052_ ? 1'b1 : nextState[0];
  assign _001_[1] = _052_ ? 1'b0 : nextState[1];
  assign _001_[2] = _052_ ? 1'b0 : nextState[2];
  assign _001_[3] = _052_ ? 1'b0 : nextState[3];
  assign _062_[0] = _075_ ? _061_[0] : 1'b0;
  assign _062_[1] = _075_ ? _061_[1] : 1'b0;
  assign _062_[2] = _075_ ? _061_[2] : 1'b0;
  assign _062_[3] = _075_ ? _016_[1] : 1'b0;
  assign _062_[6] = _075_ ? _014_[1] : 1'b0;
  assign _062_[7] = _075_ ? _015_[1] : 1'b0;
  assign _066_[0] = _065_[4] ? _065_[0] : 1'b0;
  assign _066_[1] = _065_[4] ? _020_[1] : 1'b0;
  assign _066_[4] = _065_[4] ? _065_[4] : 1'b0;
  assign _066_[5] = _065_[4] ? _021_[1] : 1'b0;
  assign _066_[6] = _065_[4] ? _065_[6] : 1'b0;
  assign DirBus[0] = memory_request ? _064_[0] : 1'b0;
  assign DirBus[1] = memory_request ? _064_[1] : 1'b0;
  assign DirBus[3] = memory_request ? _058_ : 1'b0;
  assign DirBus[4] = memory_request ? _063_[12] : 1'b0;
  assign DirBus[5] = memory_request ? _064_[5] : 1'b0;
  assign DirBus[6] = memory_request ? _063_[14] : 1'b0;
  assign nextState[0] = _076_ ? _068_[0] : state[0];
  assign nextState[1] = _076_ ? _068_[1] : state[1];
  assign nextState[2] = _076_ ? _068_[2] : state[2];
  assign nextState[3] = _076_ ? _068_[3] : state[3];
  assign _054_ = ~RxBufferFull;
  DFF _198_ (
    .C(clk),
    .D(_001_[0]),
    .Q(state[0])
  );
  DFF _199_ (
    .C(clk),
    .D(_001_[1]),
    .Q(state[1])
  );
  DFF _200_ (
    .C(clk),
    .D(_001_[2]),
    .Q(state[2])
  );
  DFF _201_ (
    .C(clk),
    .D(_001_[3]),
    .Q(state[3])
  );
  DFF _202_ (
    .C(clk),
    .D(_000_[0]),
    .Q(WriteGoodCRC_counter[0])
  );
  DFF _203_ (
    .C(clk),
    .D(_000_[1]),
    .Q(WriteGoodCRC_counter[1])
  );
  DFF _204_ (
    .C(clk),
    .D(_000_[2]),
    .Q(WriteGoodCRC_counter[2])
  );
  DFF _205_ (
    .C(clk),
    .D(_000_[3]),
    .Q(WriteGoodCRC_counter[3])
  );
  assign _055_ = RECEIVE_DETECT_IN[0] | RECEIVE_DETECT_IN[1];
  assign _056_ = _055_ | RECEIVE_DETECT_IN[2];
  assign _057_ = _056_ | RECEIVE_DETECT_IN[3];
  assign MessageRecivedFromPHY = _057_ | RECEIVE_DETECT_IN[4];
  assign _032_[3] = state[3] ^ 1'b1;
  assign _033_[0] = RX_BUF_HEADER_BYTE_0[0] ^ 1'b1;
  assign _035_[2] = state[2] ^ 1'b1;
  assign _036_[1] = state[1] ^ 1'b1;
  assign _034_[2] = WriteGoodCRC_counter[2] ^ 1'b1;
  assign _002_[0] = WriteGoodCRC_counter[0] ^ 1'b1;
  assign _037_[1] = WriteGoodCRC_counter[1] ^ 1'b1;
  assign _038_[0] = state[0] ^ 1'b1;
  assign _060_[24] = MESSAGE_HEADER_INFO_IN[0] & _024_[2];
  assign _018_[1] = RX_BUF_HEADER_BYTE_1[1] & _024_[2];
  assign _017_[1] = RX_BUF_HEADER_BYTE_1[2] & _024_[2];
  assign _016_[1] = RX_BUF_HEADER_BYTE_1[3] & _024_[2];
  assign _014_[1] = MESSAGE_HEADER_INFO_IN[1] & _060_[16];
  assign _015_[1] = MESSAGE_HEADER_INFO_IN[2] & _060_[16];
  assign _063_[8] = _066_[0] & _050_;
  assign _063_[9] = _066_[1] & _050_;
  assign _063_[12] = _066_[4] & _050_;
  assign _063_[13] = _066_[5] & _050_;
  assign _063_[14] = _066_[6] & _050_;
  assign _067_[12] = _072_[0] & _073_;
  assign _028_[1] = _072_[1] & _073_;
  assign _067_[14] = _072_[2] & _073_;
  assign _067_[15] = _072_[3] & _073_;
  assign _067_[8] = _071_[0] & _059_;
  assign _067_[10] = _071_[2] & _059_;
  assign _067_[11] = _071_[3] & _059_;
  assign _067_[4] = _070_[0] & _050_;
  assign _028_[0] = _070_[1] & _050_;
  assign _026_[0] = _070_[2] & _050_;
  assign _027_[0] = _070_[3] & _050_;
  assign _002_[1] = WriteGoodCRC_counter[1] ^ WriteGoodCRC_counter[0];
  assign _002_[2] = WriteGoodCRC_counter[2] ^ _074_[1];
  assign _002_[3] = WriteGoodCRC_counter[3] ^ _074_[2];
  assign _074_[2] = WriteGoodCRC_counter[2] & _074_[1];
  assign _074_[1] = WriteGoodCRC_counter[1] & WriteGoodCRC_counter[0];
  assign DataBusOut[5:4] = 2'b00;
  assign { DirBus[7], DirBus[2] } = { 1'b0, DirBus[3] };
  assign MessageType = RX_BUF_HEADER_BYTE_0[0];
  assign idle = state[0];
endmodule
