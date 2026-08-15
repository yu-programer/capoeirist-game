extends Node

#atacks that hurt on face: up_atack
#atacks that hurt on body or lower: down_atack

enum Type_atack {DOWN_ATACK, UP_ATACK, NOTHING}

var current_atack:Type_atack

var with_key:bool

var life:float
