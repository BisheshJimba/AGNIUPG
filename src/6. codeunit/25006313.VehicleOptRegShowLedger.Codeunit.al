codeunit 25006313 "Vehicle Opt. Reg.-Show Ledger"
{
    // 12.07.2004 EDMS P1
    //   * created

    TableNo = 25006390;

    trigger OnRun()
    begin
        recVehOptLedger.SETRANGE("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        PAGE.RUN(PAGE::"Vehicle Opt. Ledger Entries", recVehOptLedger);
    end;

    var
        recVehOptLedger: Record "25006388";
}

