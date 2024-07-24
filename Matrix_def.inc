#define FMatrix:%0(%1) FMatrix_%0(%1)

#if defined Parent
	#undef Parent
#endif
#define Parent:%0(%1) Fraction:%0(%1)

#define MATRIX_PRIVILEGE_START		0
#define MATRIX_PRIVILEGE_END 		9

#define MATRIX_CAR_START			9
#define MATRIX_CAR_END				11

#define MATRIX_CRAFT_START			11
#define MATRIX_CRAFT_END			12

#define MATRIX_SAFE_START			12
#define MATRIX_SAFE_END				14

enum E_FRACTION_MATRIX
{
	bool:F_Invite,
	bool:F_Kick,
	bool:F_Rank,
	bool:F_Div,
	bool:F_Dep,
	bool:F_Warn,
	bool:F_Prem,
	bool:F_Gov,
	bool:F_GMid,
	bool:F_Car,
	bool:F_CarRespawn,
	bool:F_Craft,
	bool:F_SafeTake,
	bool:F_SafePut
};


new E_FRACTION_MATRIX_MENU_ACTION[14][2][] = {
	{"Возможность", "Пригласить человека"},
	{"Возможность", "Выгнать человека"},
	{"Возможность", "Изменить ранг человеку"},
	{"Возможность", "Изменить отдел человеку"},
	{"Возможность", "Писать в чат депортамента"},
	{"Возможность", "Выдать выговор человеку"},
	{"Возможность", "Премировать человека"},
	{"Возможность", "Писать в гос. новости"},
	{"Возможность", "Выдать военный билет"},
	{"Доступ", "Использование автомобиля"},
	{"Возможность", "Респавн автомобиля"},
	{"Возможность", "Крафта предмета"},
	{"Возможность", "Взятия денег из сейфа"},
	{"Возможность", "Пополнения денег в сейфе"}
};

new FractionMatrix[E_FRACTION_ID][MAX_FRACTION_RANK][E_FRACTION_MATRIX];
new bool:FractionCarMatrix[MAX_VEHICLES][MAX_FRACTION_RANK];