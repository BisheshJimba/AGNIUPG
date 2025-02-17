codeunit 25006102 "Serv. Reg.-Show Ledger"
{
    TableNo = 25006168;

    trigger OnRun()
    begin
        ServLedgEntryEDMS.SETRANGE("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        PAGE.RUN(PAGE::"Service Ledger Entries EDMS", ServLedgEntryEDMS);
    end;

    var
        ServLedgEntryEDMS: Record "25006167";
}

