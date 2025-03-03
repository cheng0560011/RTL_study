`define DUMMY_PERIOD 2

module qspi_slv (
    input SCLK,
    input IO0,
    input IO1,
    input IO2,
    input IO3,
    input CS_N
);

    // 5 states: IDLE, COMMAND, ADDRESS, DUMMY, DATA
    typedef enum logic [2:0] {
        IDLE,
        INSTRUCTION,
        ADDRESS,
        ALT,
        DUMMY,
        DATA
    } state_t;

    // Control registers
    state_t state;
    reg [7:0] config_reg;
    reg [7:0] dummy_cycle;
    reg [7:0] command;
    reg [23:0] address;
    reg [7:0] alt;
    reg [7:0] data;
    reg [2:0] counter;

    reg       data_rcv;

    always @( posedge SCLK )
    begin
        if (!CS_N)
        begin
            case (state)
                IDLE: 
                begin
                    if(cs_n == 0)
                        state = INSTRUCTION;
                    else
                        state = IDLE;
                end
                INSTRUCTION:
                begin
                    if( counter < 2 ) // 8-bit for 4 inputs
                    begin
                        command [7 - counter*4 +: 4] = {IO3, IO2, IO1, IO0};
                        counter = counter + 1;
                    end
                    else
                    begin
                        // legal command or illegal command
                        counter = 0;
                        if (command == 8'h03 || command == 8'h0b || command == 8'h02 || command == 8'h20 || command == 8'h05)
                            state = ADDRESS;
                        else
                            state = IDLE;
                    end
                end
                ADDRESS:
                begin
                    if (counter < 7) // 24-bit for 4 inputs
                    begin
                        address [ 23 - counter*4 +: 4] = { IO3, IO2, IO1, IO0 };
                        counter = counter + 1;
                    end
                    else
                    begin
                        counter = 0;
                        state = ALT;
                    end
                end
                ALT:
                begin
                    if( counter < 2 ) // 8-bit for 4 inputs
                    begin
                        alt [ 7 - counter*4 +: 4] = {IO3, IO2, IO1, IO0};
                        counter = counter + 1;
                    end
                    else
                    begin
                        counter = 0;
                        state = DUMMY;
                    end
                end
                DUMMY: // dummy period according to CR settings, default as 2
                begin
                    if (counter < DUMMY_PERIOD)
                        counter = counter + 1;
                    else
                    begin
                        counter = 0;
                        state = data;
                    end
                end
                DATA:
                begin
                    data [ data_rcv ? 3 -: 4 : 7 -: 4] = { IO3, IO2, IO1, IO0 };
                    data_rcv = ~data_rcv;
                    if (data_rcv == 0)
                        $display ("Data recieve: %x\n", data);                
                end
                default:
                    state = IDLE;
            endcase
        end
        else
        begin
            command = 0;
            address = 0;
            alt = 0;
            data = 0;
            counter = 0;
            data_rcv = 0;
            state = IDLE;
        end
    end


endmodule