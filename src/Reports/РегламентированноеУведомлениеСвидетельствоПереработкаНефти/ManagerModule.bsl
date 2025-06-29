#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс
#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ПолучитьТаблицуПримененияФорматов() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуПримененияФорматов();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2023_1";
	Стр.КНД = "1111065";
	Стр.ВерсияФормата = "5.01";
	
	Возврат Результат;
КонецФункции

Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Ложь;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2023_1";
	Стр.ОписаниеФормы = "В соответствии с приказом ФНС России от 11.12.2023 № КЧ-7-15/898@";
	Стр.ДатаНачала = '20230101';
	Стр.ДатаКонца = '20991231';
	
	Возврат Результат;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2023_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2023_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2023_1" Тогда
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Электронный формат для данной формы не опубликован';
													|en = 'Электронный формат для данной формы не опубликован'"));
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция СформироватьСписокЛистов(Объект) Экспорт
	Если Объект.ИмяФормы = "Форма2023_1" Тогда 
		Возврат СформироватьСписокЛистовФорма2023_1(Объект);
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2023_1" Тогда 
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2023_1(
			УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект), УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2023_1(СведенияОтправки)
	Префикс = "ON_ZVREGNEFT";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2023_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	УведомлениеОСпецрежимахНалогообложения.ПроверкаАктуальностиФормыПриВыгрузке(
		Данные.Объект.ИмяФормы, ТаблицаОшибок, ПолучитьТаблицуФорм());
	УведомлениеОСпецрежимахНалогообложения.ПроверкаДатВУведомлении(Данные, ТаблицаОшибок);
	УведомлениеОСпецрежимахНалогообложения.ПолнаяПроверкаЗаполненныхПоказателейНаСоотвествиеСписку(
		"СпискиВыбора2023_1", "СхемаВыгрузкиФорма2023_1",
		Данные.Объект.ИмяОтчета, ТаблицаОшибок, Данные);
	
	Титульная = Данные.ДанныеУведомления.Титульная;
	УведомлениеОСпецрежимахНалогообложенияСлужебный.ПроверкаИННКПП(Истина, Титульная, ТаблицаОшибок);
	УведомлениеОСпецрежимахНалогообложенияСлужебный.ПроверкаКодаНО(Титульная.КодНО, ТаблицаОшибок, "Титульная");
	УведомлениеОСпецрежимахНалогообложенияСлужебный.ПроверкаПодписантаНалоговойОтчетности(Данные, ТаблицаОшибок, "Титульная", Истина);
	Если Не ЗначениеЗаполнено(Титульная.НаимОрг) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указано наименование организации", "Титульная", "НаимОрг"));
	КонецЕсли;
	Если Титульная.ПРИЗНАК_НП_ПОДВАЛ = "2" И (Не ЗначениеЗаполнено(Титульная.НаимДок)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Необходимо указать документ представителя", "Титульная", "НаимДок"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ПРИЗНАК_НП_ПОДВАЛ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан признак подписанта", "Титульная", "ПРИЗНАК_НП_ПОДВАЛ"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.ДАТА_ПОДПИСИ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указана дата подписи", "Титульная", "ДАТА_ПОДПИСИ"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульная.ПоСост) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указана дата", "Титульная", "ПоСост"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.МестоНахож) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указано место нахождения", "Титульная", "МестоНахож"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульная.АдрОсущ) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Не указан адрес места осуществления деятельности", "Титульная", "АдрОсущ"));
	КонецЕсли;
	Если Титульная.Флаг1 = Ложь И Титульная.Флаг2 = Ложь И Титульная.Флаг3 = Ложь И Титульная.Флаг4 = Ложь И Титульная.Флаг5 = Ложь Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
			"Должен быть выбран хотя бы один из видов деятельности", "Титульная", "Флаг1"));
	КонецЕсли;
	
	Для Каждого ПерПроизвДата Из Данные.ДанныеМногостраничныхРазделов.ПерПроизвДата Цикл 
		Элт = ПерПроизвДата.Значение;
		
		Если Не ЗначениеЗаполнено(Элт.НаимПроизв) Тогда
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указано наименование", "ПерПроизвДата", "НаимПроизв", Элт.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Элт.РеквДокПроизв) Тогда
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан документ с реквизитами", "ПерПроизвДата", "РеквДокПроизв", Элт.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Элт.МестоНахож) Тогда
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указано место нахождения", "ПерПроизвДата", "МестоНахож", Элт.УИД));
		КонецЕсли;
	КонецЦикла;
	Для Каждого ТехнПроц Из Данные.ДанныеМногостраничныхРазделов.ТехнПроц Цикл 
		Элт = ТехнПроц.Значение;
		
		Если Не ЗначениеЗаполнено(Элт.ВидТехн) Тогда
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан вид процесса", "ТехнПроц", "ВидТехн", Элт.УИД));
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Элт.РеквДокТехн) Тогда
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
				"Не указан документ с реквизитами", "ТехнПроц", "РеквДокТехн", Элт.УИД));
		КонецЕсли;
		
		Инд = 0;
		Для Каждого Стр Из Данные.ДанныеДопСтрокБД.МнгСтр1 Цикл 
			Если Стр.УИД = Элт.УИД Тогда 
				Инд = Инд + 1;
				
				Если Не ЗначениеЗаполнено(Стр.Вид) Тогда
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
						"Не указан вид", "ТехнПроц", "Вид___" + Инд, Элт.УИД));
				КонецЕсли;
				Если Не ЗначениеЗаполнено(Стр.РеквДокСредств) Тогда
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
						"Не указан документ с реквизитами", "ТехнПроц", "РеквДокСредств___" + Инд, Элт.УИД));
				КонецЕсли;
				Если Не ЗначениеЗаполнено(Стр.МестоРазм) Тогда
					ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам(
						"Не указано место размещения", "ТехнПроц", "МестоРазм___" + Инд, Элт.УИД));
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ТаблицаОшибок;
КонецФункции

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2023_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Документы.УведомлениеОСпецрежимахНалогообложения.НачальнаяИнициализацияОбщихРеквизитовВыгрузки(Объект);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2023_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	Возврат ОсновныеСведения;
КонецФункции

Процедура ДополнитьДанные_Форма2023_1(ДанныеУведомления)
	Для Инд = 1 По 5 Цикл 
		Если ДанныеУведомления.ДанныеУведомления.Титульная["Флаг" + Инд] = Истина Тогда 
			ДанныеУведомления.ДанныеУведомления.Титульная.Вставить("ВидДеят" + Инд, Строка(Инд));
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ЭлектронноеПредставление_Форма2023_1(Объект, УникальныйИдентификатор)
	СведенияЭлектронногоПредставления = УведомлениеОСпецрежимахНалогообложения.СведенияЭлектронногоПредставления();
	ДанныеУведомления = УведомлениеОСпецрежимахНалогообложения.ДанныеУведомленияДляВыгрузки(Объект);
	ДополнитьДанные_Форма2023_1(ДанныеУведомления);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2023_1(ДанныеУведомления, УникальныйИдентификатор);
	УведомлениеОСпецрежимахНалогообложения.СообщитьОшибкиПриПроверкеВыгрузки(Объект, Ошибки, ДанныеУведомления);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2023_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2023_1");
	УведомлениеОСпецрежимахНалогообложения.ТиповоеЗаполнениеДанными(ДанныеУведомления, ОсновныеСведения, СтруктураВыгрузки);
	УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВТаблицу(СтруктураВыгрузки, ОсновныеСведения, СведенияЭлектронногоПредставления);
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Функция СформироватьСписокЛистовФорма2023_1(Объект) Экспорт
	Листы = Новый СписокЗначений;
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	СтруктураПараметров = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Ссылка, "ДанныеУведомления").Получить();
	Титульная = СтруктураПараметров.ДанныеУведомления.Титульная;
	ИННКПП = Новый Структура;
	ИННКПП.Вставить("Наименование", Титульная.НаимОрг + ?(ЗначениеЗаполнено(Титульная.НаимОргСокр), " / " + Титульная.НаимОргСокр, ""));
	ИННКПП.Вставить("ПодпФ", Объект.ПодписантФамилия);
	ИННКПП.Вставить("ПодпИ", Объект.ПодписантИмя);
	ИННКПП.Вставить("ПодпО", Объект.ПодписантОтчество);
	ИННКПП.Вставить("Признак1", ?(Титульная.Флаг1 = Истина, "V", "-"));
	ИННКПП.Вставить("Признак2", ?(Титульная.Флаг2 = Истина, "V", "-"));
	ИННКПП.Вставить("Признак3", ?(Титульная.Флаг3 = Истина, "V", "-"));
	ИННКПП.Вставить("Признак4", ?(Титульная.Флаг4 = Истина, "V", "-"));
	ИННКПП.Вставить("Признак5", ?(Титульная.Флаг5 = Истина, "V", "-"));
	Титульная.Вставить("Наименование", ИННКПП.Наименование);
	
	УведомлениеОСпецрежимахНалогообложения.НапечататьСтруктуру(Объект.ИмяОтчета,
		СтруктураПараметров.ДанныеУведомления["Титульная"], 0, "Печать_Форма2023_1_Титульная", ПечатнаяФорма, ИННКПП);
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, 1);
	
	ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_Форма2023_1_Приложение");
	Заголовок = МакетУведомления.ПолучитьОбласть("Заголовок");
	ЗаполнитьЗначенияСвойств(Заголовок.Параметры, Титульная);
	ПечатнаяФорма.Вывести(Заголовок);
	
	Инд = 0;
	НомСтр = 2;
	Для Каждого Стр2 Из СтруктураПараметров.ДанныеДопСтрокБД.МнгСтр1 Цикл 
		Для Каждого Стр1 Из СтруктураПараметров.ДанныеМногостраничныхРазделов.ТехнПроц Цикл 
			Если Стр1.Значение.УИД = Стр2.УИД Тогда
				Для Каждого Стр0 Из СтруктураПараметров.ДанныеМногостраничныхРазделов.ПерПроизвДата Цикл 
					Если Стр1.Значение.УИДРодителя = Стр0.Значение.УИД Тогда
						Инд = Инд + 1;
						СтрокаДанных = МакетУведомления.ПолучитьОбласть("СтрокаДанных");
						СтрокаДанных.Параметры.НомПП = Инд;
						ЗаполнитьЗначенияСвойств(СтрокаДанных.Параметры, Стр0.Значение);
						ЗаполнитьЗначенияСвойств(СтрокаДанных.Параметры, Стр1.Значение);
						ЗаполнитьЗначенияСвойств(СтрокаДанных.Параметры, Стр2);
						
						Если ПечатнаяФорма.ВысотаТаблицы <> 0 И Не ПечатнаяФорма.ПроверитьВывод(СтрокаДанных) Тогда 
							УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
							НомСтр = НомСтр + 1;
							ПечатнаяФорма = УведомлениеОСпецрежимахНалогообложения.НовыйПустойЛист();
							ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
						КонецЕсли;
						ПечатнаяФорма.Вывести(СтрокаДанных);
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	Подвал = МакетУведомления.ПолучитьОбласть("Подвал");
	ЗаполнитьЗначенияСвойств(Подвал.Параметры, Титульная);
	ПечатнаяФорма.Вывести(Подвал);
	
	УведомлениеОСпецрежимахНалогообложения.ПоложитьПФВСписокЛистов(Объект, Листы, ПечатнаяФорма, НомСтр, Ложь);
	Возврат Листы;
КонецФункции

#КонецОбласти
#КонецЕсли
