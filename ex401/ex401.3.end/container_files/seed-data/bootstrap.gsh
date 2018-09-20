gs = GrouperSession.startRootSession();

addStem("ref", "board", "board");

group = GroupFinder.findByName(gs, "app:boardeffect:ref:cmt_fin", true);
stem = StemFinder.findByName(gs, "ref:board", true);
group.move(stem);

addStem("ref:board", "etc", "etc");
addGroup("ref:board:etc", "board_managers", "board_managers");

addMember("ref:board:etc:board_managers", "ref:roles:president_assistant");
