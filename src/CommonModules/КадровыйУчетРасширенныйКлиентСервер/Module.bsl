////////////////////////////////////////////////////////////////////////////////
// КадровыйУчетРасширенныйКлиентСервер: методы кадрового учета, работающие на стороне клиента и сервера.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции


#Область ИтогиПодсчетаСтажаТрудовойДеятельностиОтчетыПоСотрудникамТрудоваяДеятельность

Функция ДнейМесяцаПриПодсчетеСтажа(Знач Дней) Экспорт
	
	Если ТипЗнч(Дней) <> Тип("Число") Тогда
		Дней = 0;
	КонецЕсли;
	
	Возврат Дней - ЦелыхМесяцевВДняхСтажа(Дней) * 30;
	
КонецФункции

Функция МесяцевГодаПриПодсчетеСтажа(Знач Месяцев, Знач Дней) Экспорт
	
	Если ТипЗнч(Дней) <> Тип("Число") Тогда
		Дней = 0;
	КонецЕсли;
	
	Если ТипЗнч(Месяцев) <> Тип("Число") Тогда
		Месяцев = 0;
	КонецЕсли;
	
	Месяцев = Месяцев + ЦелыхМесяцевВДняхСтажа(Дней);
	Возврат Месяцев - ЦелыхЛетВМесяцахСтажа(Месяцев) * 12;
	
КонецФункции

Функция ЛетПриПодсчетеСтажа(Знач Лет, Знач Месяцев, Знач Дней) Экспорт
	
	Если ТипЗнч(Дней) <> Тип("Число") Тогда
		Дней = 0;
	КонецЕсли;
	
	Если ТипЗнч(Месяцев) <> Тип("Число") Тогда
		Месяцев = 0;
	КонецЕсли;
	
	Если ТипЗнч(Лет) <> Тип("Число") Тогда
		Лет = 0;
	КонецЕсли;
	
	Возврат Лет + ЦелыхЛетВМесяцахСтажа(Месяцев + ЦелыхМесяцевВДняхСтажа(Дней));
	
КонецФункции

Функция ЦелыхМесяцевВДняхСтажа(Знач Дней)
	
	Возврат Цел(Дней / 30);
	
КонецФункции

Функция ЦелыхЛетВМесяцахСтажа(Знач Месяцев)
	
	Возврат Цел(Месяцев / 12);
	
КонецФункции

#КонецОбласти


Функция КомментарийККоличествуСтавок(ТекущееКоличествоСтавок, НовоеКоличествоСтавок, ИзменитьПозицию) Экспорт 
	
	Если ТекущееКоличествоСтавок = 0 Тогда
		Возврат "";
	Иначе
		
		Если НЕ ИзменитьПозицию ИЛИ НовоеКоличествоСтавок = ТекущееКоличествоСтавок Тогда
			Возврат "";
		Иначе
			
			Если НовоеКоличествоСтавок > ТекущееКоличествоСтавок Тогда
				Возврат "(+" + Формат(НовоеКоличествоСтавок - ТекущееКоличествоСтавок, "ЧН=' '") + ")";
			Иначе
				Возврат "(" + Формат(НовоеКоличествоСтавок - ТекущееКоличествоСтавок, "ЧН=' '") + ")";
			КонецЕсли;		
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции	

Функция ДанныеОНачисленияхВФорме(Форма, Начисления, Показатели, ОписаниеТаблицыВидовРасчета) Экспорт
	
	МаксимальноеКоличествоПоказателей = ЗарплатаКадрыРасширенныйКлиентСервер.МаксимальноеКоличествоПоказателейПоОписаниюТаблицы(
		Форма, ОписаниеТаблицыВидовРасчета);
	
	ДанныеОНачислениях = Новый Массив;
	Для Каждого СтрокаНачислений Из Начисления Цикл
		Если СтрокаНачислений.Свойство("Действие")
			И СтрокаНачислений.Действие = ПредопределенноеЗначение("Перечисление.ДействияСНачислениямиИУдержаниями.Отменить") Тогда
			Продолжить;
		КонецЕсли;
		УНачисленияЕстьПоказатели = Ложь;
		Для НомерПоказателя = 1 По МаксимальноеКоличествоПоказателей Цикл
			Если СтрокаНачислений["Показатель" + НомерПоказателя].Пустая() Тогда
				Прервать;
			КонецЕсли;
			УНачисленияЕстьПоказатели = Истина;
			СтруктураНачисления = Новый Структура("Начисление,Показатель,Значение", СтрокаНачислений.Начисление, СтрокаНачислений["Показатель" + НомерПоказателя], СтрокаНачислений["Значение" + НомерПоказателя]);
			ДанныеОНачислениях.Добавить(СтруктураНачисления);
		КонецЦикла;
		Если Не УНачисленияЕстьПоказатели Тогда
			СтруктураНачисления = Новый Структура("Начисление,Показатель,Значение", СтрокаНачислений.Начисление);
			Если СтрокаНачислений.Свойство("ФиксированнаяСумма") И СтрокаНачислений.ФиксированнаяСумма Тогда 
				СтруктураНачисления.Значение = СтрокаНачислений.Значение1;
			КонецЕсли;
			ДанныеОНачислениях.Добавить(СтруктураНачисления);
		КонецЕсли; 
	КонецЦикла;
	
	Если ЗарплатаКадрыРасширенныйКлиентСервер.РедактироватьНачисленияВОтдельныхПолях(1, ОписаниеТаблицыВидовРасчета) Тогда

		// Районный коэффициент
		Если ЗарплатаКадрыРасширенныйКлиентСервер.РайонныйКоэффициентПрименяется(Форма) Тогда
				
			СтруктураНачисления = Новый Структура;
			СтруктураНачисления.Вставить("Начисление", ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "НачислениеРайонныйКоэффициент"));
			СтруктураНачисления.Вставить("Показатель", ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.РайонныйКоэффициент"));
			СтруктураНачисления.Вставить("Значение", ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "ЗначениеПоказателяРайонныйКоэффициент"));
			
			ДанныеОНачислениях.Добавить(СтруктураНачисления);
				
		КонецЕсли; 
			
		// Северная надбавка
		Если ЗарплатаКадрыРасширенныйКлиентСервер.СевернаяНадбавкаПрименяется(Форма) Тогда
				
			СтруктураНачисления = Новый Структура;
			СтруктураНачисления.Вставить("Начисление", ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "НачислениеСевернаяНадбавка"));
			СтруктураНачисления.Вставить("Показатель");
			СтруктураНачисления.Вставить("Значение");
			
			ДанныеОНачислениях.Добавить(СтруктураНачисления);
				
		КонецЕсли; 
		
		// Надбавка за вредность
		Если ЗарплатаКадрыРасширенныйКлиентСервер.НадбавкаЗаВредностьПрименяется(Форма) Тогда
				
			СтруктураНачисления = Новый Структура;
			СтруктураНачисления.Вставить("Начисление", ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "НачислениеНадбавкаЗаВредность"));
			СтруктураНачисления.Вставить("Показатель", ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.ПроцентНадбавкиЗаВредность"));
			СтруктураНачисления.Вставить("Значение", ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "ЗначениеПоказателяНадбавкаЗаВредность"));
			
			ДанныеОНачислениях.Добавить(СтруктураНачисления);
				
		КонецЕсли; 
		
	КонецЕсли;
		
	НезависимыеПоказатели = Показатели.НайтиСтроки(Новый Структура("ИдентификаторСтрокиВидаРасчета", 0));
	Для Каждого СтрокаПоказателя Из НезависимыеПоказатели Цикл 
		Если СтрокаПоказателя.Свойство("Действие")
			И СтрокаПоказателя.Действие = ПредопределенноеЗначение("Перечисление.ДействияСНачислениямиИУдержаниями.Отменить") Тогда
			Продолжить;
		КонецЕсли;
		СтруктураПоказателя = Новый Структура("Начисление,Показатель,Значение", ПредопределенноеЗначение("ПланВидовРасчета.Начисления.ПустаяСсылка"), СтрокаПоказателя.Показатель, СтрокаПоказателя.Значение);
		ДанныеОНачислениях.Добавить(СтруктураПоказателя);
	КонецЦикла; 
	Возврат ДанныеОНачислениях;
КонецФункции

Процедура ОбработкаПолученияДанныхВыбораВидовЗанятости(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Если НЕ Параметры.Отбор.Свойство("Ссылка") Тогда
		
		МассивДоступныхСсылок = Новый Массив;
		
		Если Параметры.Отбор.Свойство("ТекущийВидЗанятости")
			И ЗначениеЗаполнено(Параметры.Отбор.ТекущийВидЗанятости) Тогда
			
			Если Параметры.Отбор.ТекущийВидЗанятости = ПредопределенноеЗначение("Перечисление.ВидыЗанятости.ОсновноеМестоРаботы")
				Или Параметры.Отбор.ТекущийВидЗанятости = ПредопределенноеЗначение("Перечисление.ВидыЗанятости.Совместительство") Тогда
				
				МассивДоступныхСсылок.Добавить(ПредопределенноеЗначение("Перечисление.ВидыЗанятости.ОсновноеМестоРаботы"));
				МассивДоступныхСсылок.Добавить(ПредопределенноеЗначение("Перечисление.ВидыЗанятости.Совместительство"));
				
			Иначе
				МассивДоступныхСсылок.Добавить(Параметры.Отбор.ТекущийВидЗанятости);
			КонецЕсли;
			
		Иначе
			
			МассивДоступныхСсылок.Добавить(ПредопределенноеЗначение("Перечисление.ВидыЗанятости.ОсновноеМестоРаботы"));
			МассивДоступныхСсылок.Добавить(ПредопределенноеЗначение("Перечисление.ВидыЗанятости.Совместительство"));
			МассивДоступныхСсылок.Добавить(ПредопределенноеЗначение("Перечисление.ВидыЗанятости.ВнутреннееСовместительство"));
			
		КонецЕсли;
		
		Параметры.Отбор.Вставить("Ссылка", МассивДоступныхСсылок);
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПредставлениеЛет(Лет) Экспорт
	Возврат СтрШаблон("%1 %2", Формат(Лет, "ЧЦ=3"), СтроковыеФункцииКлиентСервер.ФормаМножественногоЧисла(НСтр("ru = 'год';
																												|en = 'year'"), НСтр("ru = 'года';
																																|en = 'year'"), НСтр("ru = 'лет';
																																					|en = 'years'"), Лет));
КонецФункции

Функция ПредставлениеМесяцев(Месяцев) Экспорт
	Возврат СтрШаблон("%1 %2", Формат(Месяцев, "ЧЦ=2"), СтроковыеФункцииКлиентСервер.ФормаМножественногоЧисла(НСтр("ru = 'месяц';
																													|en = 'month'"), НСтр("ru = 'месяца';
																																		|en = 'month'"), НСтр("ru = 'месяцев';
																																							|en = 'months'"), Месяцев));
КонецФункции

Функция ПредставлениеДней(Дней) Экспорт
	Возврат СтрШаблон("%1 %2", Формат(Дней, "ЧЦ=2"), СтроковыеФункцииКлиентСервер.ФормаМножественногоЧисла(НСтр("ru = 'день';
																												|en = 'Day'"), НСтр("ru = 'дня';
																																	|en = 'days'"), НСтр("ru = 'дней';
																																					|en = 'days'"), Дней));
КонецФункции


#Область УстановкаДоступностиКоманднойПанели

Процедура УстановитьДоступностьКоманднойПанели(Форма, ИмяКоманднойПанели, Доступность) Экспорт
	
	КоманднаяПанель = Форма.Элементы.Найти(ИмяКоманднойПанели);
	Если КоманднаяПанель = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	УстановитьДоступностьЭлементовКоманднойПанели(КоманднаяПанель, Доступность);
	
КонецПроцедуры

Процедура УстановитьДоступностьЭлементовКоманднойПанели(КоманднаяПанель, Доступность)
	
	Для каждого ЭлементПанели Из КоманднаяПанель.ПодчиненныеЭлементы Цикл
		
		Если ЭлементПанели.Вид = ВидГруппыФормы.Страницы
			ИЛИ ЭлементПанели.Вид = ВидГруппыФормы.Страница Тогда
			УстановитьДоступностьЭлементовКоманднойПанели(ЭлементПанели, Доступность);
		Иначе
			ЭлементПанели.Доступность = Доступность;
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти


#Область ОписанияДокументаУвольнение

Функция ОписаниеТаблицыНачислений(ПравоНаЧтениеДокументаБезОграничений) Экспорт
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	
	ОписаниеТаблицы.ИмяТаблицы						= "Начисления";
	ОписаниеТаблицы.ПутьКДанным						= "Объект.Начисления";
	ОписаниеТаблицы.ИмяПоляДляВставкиПоказателей	= "ДатыНачисления";
	
	ОписаниеТаблицы.ОтображатьПоляОписанияВремени				= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.ОтображатьПоляНормыВремени					= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.УправлятьОтображениемПолейОписанияВремени	= ПравоНаЧтениеДокументаБезОграничений;
	
	ОписаниеТаблицы.ИмяПоляДляВставкиРаспределенияРезультатов 	= "НачисленияРезультат";
	ОписаниеТаблицы.ВставлятьПослеПоля 							= Истина;
	ОписаниеТаблицы.ОтображатьПоляРаспределенияРезультатов 		= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.РаспределениеРезультатовЗависимыеТаблицы    = "Начисления,Пособия,Удержания,НДФЛ,КорректировкиВыплаты";
	
	ОписаниеТаблицы.ИмяРеквизитаПериод 							= "ПериодРегистрации";
	ОписаниеТаблицы.ИмяРеквизитаДокументОснование 				= "ДокументОснование";
	
	ОписаниеТаблицы.СодержитПолеКодВычета 						= Истина;
	ОписаниеТаблицы.СодержитПолеМестоПолученияДохода 			= Истина;
	
	Возврат ОписаниеТаблицы;
	
КонецФункции

Функция ОписаниеТаблицыУдержаний(ПравоНаЧтениеДокументаБезОграничений) Экспорт
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицы.ИмяТаблицы = "Удержания";
	ОписаниеТаблицы.ПутьКДанным = "Объект.Удержания";
	ОписаниеТаблицы.ИмяРеквизитаВидРасчета = "Удержание";
	ОписаниеТаблицы.ИмяПоляДляВставкиПоказателей = "УдержанияРезультат";
	ОписаниеТаблицы.ИмяРеквизитаСотрудник = "ФизическоеЛицо";
	ОписаниеТаблицы.НомерТаблицы = 2;
	
	ОписаниеТаблицы.ПутьКДаннымРаспределениеРезультатов = "Объект.РаспределениеРезультатовУдержаний";
	ОписаниеТаблицы.ИмяПоляДляВставкиРаспределенияРезультатов 	= "УдержанияРезультат";
	ОписаниеТаблицы.ВставлятьПослеПоля 							= Истина;
	ОписаниеТаблицы.ОтображатьПоляРаспределенияРезультатов = ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.ИмяРеквизитаПериод 				= "ПериодРегистрации";
	
	Возврат ОписаниеТаблицы;
	
КонецФункции

Функция ОписаниеТаблицыНДФЛ(ПравоНаЧтениеДокументаБезОграничений) Экспорт
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицы.ИмяТаблицы 						= "НДФЛ";
	ОписаниеТаблицы.ПутьКДанным 					= "Объект.НДФЛ";
	ОписаниеТаблицы.ИмяПоляДляВставкиПоказателей 	= "Налог";
	ОписаниеТаблицы.ИмяРеквизитаСотрудник 			= "ФизическоеЛицо";
	ОписаниеТаблицы.ИмяПоляРезультат 				= "Налог";
	ОписаниеТаблицы.ИмяРеквизитаПериод 				= "МесяцНалоговогоПериода";
	ОписаниеТаблицы.НомерТаблицы 					= 3;
	ОписаниеТаблицы.СодержитПолеВидРасчета 			= Ложь;
	
	ОписаниеТаблицы.Вставить("ИмяРеквизитаПодразделение", "Подразделение");
	
	ОписаниеТаблицы.ПутьКДаннымРаспределениеРезультатов = "Объект.РаспределениеРезультатовУдержаний";
	ОписаниеТаблицы.ИмяРеквизитаИдентификаторСтроки = "ИдентификаторСтрокиНДФЛ";
	ОписаниеТаблицы.ИмяПоляДляВставкиРаспределенияРезультатов = "НДФЛМесяцНалоговогоПериода";
	ОписаниеТаблицы.ОтображатьПоляРаспределенияРезультатов = ПравоНаЧтениеДокументаБезОграничений;
	
	Возврат ОписаниеТаблицы;
	
КонецФункции

Функция ОписаниеТаблицыКорректировкиВыплаты(ПравоНаЧтениеДокументаБезОграничений) Экспорт
	
	Описание = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыКорректировкиВыплаты();
	Описание.ПроверяемыеРеквизиты = "ФизическоеЛицо";
	Описание.ОтображатьПоляРаспределенияРезультатов = ПравоНаЧтениеДокументаБезОграничений;
	
	Возврат Описание;
	
КонецФункции

Функция ОписаниеТаблицыПособия(ПравоНаЧтениеДокументаБезОграничений) Экспорт
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицы.СодержитПолеСотрудник = Истина;
	ОписаниеТаблицы.ИмяРеквизитаСотрудник = "Сотрудник";
	ОписаниеТаблицы.ИмяПоляДляВставкиПоказателей = "ДатыПособия";
	ОписаниеТаблицы.ИмяТаблицы = "Пособия";
	ОписаниеТаблицы.ПутьКДанным = "Объект.Пособия";
	ОписаниеТаблицы.НомерТаблицы = 4;
	
	ОписаниеТаблицы.ИмяПоляДляВставкиРаспределенияРезультатов 	= "ПособияОплаченоДней";
	ОписаниеТаблицы.ОтображатьПоляРаспределенияРезультатов 	= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.РаспределениеРезультатовЗависимыеТаблицы    = "Удержания,НДФЛ,КорректировкиВыплаты";
	ОписаниеТаблицы.ИмяРеквизитаПериод 				= "ПериодРегистрации";
	
	ОписаниеТаблицы.ОтменятьВсеИсправления	= Истина;
	
	Возврат ОписаниеТаблицы;
	
КонецФункции

Функция ОписаниеТаблицыПогашениеЗаймов(ПравоНаЧтениеДокументаБезОграничений) Экспорт
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицы.ИмяТаблицы = "ПогашениеЗаймов";
	ОписаниеТаблицы.ПутьКДанным = "Объект.ПогашениеЗаймов";
	ОписаниеТаблицы.СодержитПолеВидРасчета = Ложь;
	ОписаниеТаблицы.НомерТаблицы = 5;
	ОписаниеТаблицы.ПутьКДаннымРаспределениеРезультатов = "Объект.РаспределениеРезультатовУдержаний";
	ОписаниеТаблицы.ИмяРеквизитаСотрудник = "ФизическоеЛицо";
	
	ОписаниеТаблицы.ИмяРеквизитаИдентификаторСтроки = "ИдентификаторСтроки";
	ОписаниеТаблицы.ОтображатьПоляРаспределенияРезультатов = ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.УстанавливатьИдентификаторСтрокиРаспределенияРезультата = Истина;
	
	ОписаниеТаблицы.ОтменятьВсеИсправления	= Истина;
	
	Возврат ОписаниеТаблицы;
	
КонецФункции

Функция ОписаниеТаблицыПерерасчетов(ПравоНаЧтениеДокументаБезОграничений) Экспорт
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	
	ОписаниеТаблицы.ИмяТаблицы						= "НачисленияПерерасчет";
	ОписаниеТаблицы.ПутьКДанным						= "Объект.НачисленияПерерасчет";
	ОписаниеТаблицы.ИмяПоляДляВставкиПоказателей	= "ДатыНачисленияПерерасчет";
	ОписаниеТаблицы.СодержитПолеСотрудник			= Истина;
	ОписаниеТаблицы.ИмяРеквизитаСотрудник			= "Сотрудник";
	ОписаниеТаблицы.НомерТаблицы 					= 6;
	
	ОписаниеТаблицы.ОтображатьПоляОписанияВремени 				= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.ОтображатьПоляНормыВремени					= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.УправлятьОтображениемПолейОписанияВремени	= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.ЭтоПерерасчеты = Истина;
	ОписаниеТаблицы.ИмяРеквизитаФиксСторно = "ФиксСторно";
	
	ОписаниеТаблицы.ИмяПоляДляВставкиРаспределенияРезультатов 	= "НачисленияПерерасчетРезультат";
	ОписаниеТаблицы.ВставлятьПослеПоля 							= Истина;
	ОписаниеТаблицы.ОтображатьПоляРаспределенияРезультатов 		= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.РаспределениеРезультатовЗависимыеТаблицы    = "НачисленияПерерасчет,Удержания,НДФЛ,КорректировкиВыплаты";
	
	ОписаниеТаблицы.ИмяРеквизитаПериод 				= "ПериодРегистрации";
	ОписаниеТаблицы.ИмяРеквизитаДокументОснование 	= "ДокументОснование";
	
	ОписаниеТаблицы.СодержитПолеМестоПолученияДохода = Истина;
	ОписаниеТаблицы.СодержитРегистраторРазовогоНачисления = Истина;
	
	Возврат ОписаниеТаблицы;
	
КонецФункции	

Функция ОписаниеТаблицыПособияПерерасчеты(ПравоНаЧтениеДокументаБезОграничений) Экспорт
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицы.СодержитПолеСотрудник = Истина;
	ОписаниеТаблицы.ИмяРеквизитаСотрудник = "Сотрудник";
	ОписаниеТаблицы.ИмяПоляДляВставкиПоказателей = "ПерерасчетДатыПособия";
	ОписаниеТаблицы.ИмяТаблицы = "ПособияПерерасчет";
	ОписаниеТаблицы.ПутьКДанным = "Объект.ПособияПерерасчет";
	ОписаниеТаблицы.НомерТаблицы = 7;
	
	ОписаниеТаблицы.ИмяПоляДляВставкиРаспределенияРезультатов 	= "ПособияПерерасчетОплаченоДней";
	ОписаниеТаблицы.ОтображатьПоляРаспределенияРезультатов 	= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.РаспределениеРезультатовЗависимыеТаблицы    = "ПособияПерерасчет,Удержания,НДФЛ,КорректировкиВыплаты";
	ОписаниеТаблицы.ИмяРеквизитаПериод 				= "ПериодРегистрации";
	
	ОписаниеТаблицы.ЭтоПерерасчеты = Истина;
	ОписаниеТаблицы.ИмяРеквизитаФиксСторно = "ФиксСторно";

	ОписаниеТаблицы.ОтменятьВсеИсправления	= Истина;
	
	Возврат ОписаниеТаблицы;
	
КонецФункции

Функция ОписаниеТаблицыЛьгот(ПравоНаЧтениеДокументаБезОграничений) Экспорт
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицы.ИмяТаблицы = "Льготы";
	ОписаниеТаблицы.ПутьКДанным = "Объект.Льготы";
	ОписаниеТаблицы.СодержитПолеСотрудник = Истина;
	ОписаниеТаблицы.ИмяРеквизитаСотрудник = "Сотрудник";
	ОписаниеТаблицы.ИмяПоляДляВставкиПоказателей = "ДатыЛьготы";
	ОписаниеТаблицы.СодержитПолеКодВычета = Истина;
	ОписаниеТаблицы.НомерТаблицы = 8;
	
	ОписаниеТаблицы.ОтображатьПоляОписанияВремени				= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.ОтображатьПоляНормыВремени					= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.УправлятьОтображениемПолейОписанияВремени	= ПравоНаЧтениеДокументаБезОграничений;
	
	ОписаниеТаблицы.ИмяПоляДляВставкиРаспределенияРезультатов 	= "ЛьготыРезультат";
	ОписаниеТаблицы.ВставлятьПослеПоля 							= Истина;
	ОписаниеТаблицы.ОтображатьПоляРаспределенияРезультатов 		= ПравоНаЧтениеДокументаБезОграничений;
	ОписаниеТаблицы.РаспределениеРезультатовЗависимыеТаблицы    = "Удержания,НДФЛ,КорректировкиВыплаты";
	ОписаниеТаблицы.ИмяРеквизитаПериод 							= "ПериодРегистрации";
	
	ОписаниеТаблицы.ОтменятьВсеИсправления	= Истина;
	
	ОписаниеТаблицы.СодержитПолеМестоПолученияДохода = Истина;
	
	Возврат ОписаниеТаблицы;

КонецФункции

Функция ОписаниеТаблицыСохраняемоеДенежноеСодержание() Экспорт

	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	
	ОписаниеТаблицы.ИмяТаблицы									= "ДенежноеСодержание";
	ОписаниеТаблицы.ПутьКДанным									= "Объект.ДенежноеСодержание";
	ОписаниеТаблицы.ИмяРеквизитаСотрудник						= "Сотрудник";
	ОписаниеТаблицы.ИмяРеквизитаПериод 							= "ПериодРегистрации";
	ОписаниеТаблицы.НомерТаблицы = 6.1;
	
	Возврат ОписаниеТаблицы;	

КонецФункции

Функция ЭтоСреднечасовойЗаработокВДокументеУвольнение() Экспорт
	Возврат Ложь;
КонецФункции

Функция ОписаниеДокумента(ПараметрыОписания) Экспорт
	
	ИзменениеБезОграничений 			= ПараметрыОписания.ИзменениеБезОграничений;
	РегистрацияНачисленийДоступна 		= ПараметрыОписания.РегистрацияНачисленийДоступна;
	СпособыРасчетаСреднегоЗаработка 	= ПараметрыОписания.СпособыРасчетаСреднегоЗаработка;
	ПризнакКомпенсацииУдержанияОтпуска 	= ПараметрыОписания.ПризнакКомпенсацииУдержанияОтпуска;
	
	Описание = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеРасчетногоДокумента();
	Описание.МесяцНачисленияИмя = "ПериодРегистрации";
	Описание.НачисленияИмя = "Начисления";
	Описание.НачисленияПерерасчетИмя = "НачисленияПерерасчет";
	Описание.ПособияИмя = "Пособия";
	Описание.ПособияПерерасчетИмя = "ПособияПерерасчет";
	Описание.УдержанияИмя = "Удержания";
	Описание.НДФЛИмя = "НДФЛ";
	Описание.КорректировкиВыплатыИмя = "КорректировкиВыплаты";
	Описание.ВзносыИмя = "Взносы";
	Описание.ПримененныеВычетыИмя = "ПримененныеВычетыНаДетейИИмущественные";
	Описание.ПогашениеЗаймовИмя = "ПогашениеЗаймов";
	
	Описание.РежимНачисления = ПредопределенноеЗначение("Перечисление.РежимНачисленияЗарплаты.ОкончательныйРасчет");
	Описание.Окончание = "ДатаУвольнения";
	Описание.РегистрацияНачисленийДоступна = ИзменениеБезОграничений;
	Описание.ЕстьОплатаПоСреднему = Истина;
	Описание.СпособыРасчетаСреднегоЗаработка = СпособыРасчетаСреднегоЗаработка;
	Описание.ЭтоСреднеЧасовойЗаработок = ЭтоСреднечасовойЗаработокВДокументеУвольнение();
	Описание.ДатаНачалаСобытияИмя = "ДатаУвольнения";
	
	Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда
		МодульЛьготыСотрудниковКлиентСервер = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("ЛьготыСотрудниковКлиентСервер");
		МодульЛьготыСотрудниковКлиентСервер.ДополнитьОписаниеДокументаНачислениеЗарплаты(Описание);
	КонецЕсли;
	
	Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		МодульУправленческаяЗарплатаКлиентСервер = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("УправленческаяЗарплатаКлиентСервер");
		МодульУправленческаяЗарплатаКлиентСервер.ДополнитьОписаниеРасчетногоДокумента(Описание);
	КонецЕсли;
	
	Описание.ОбязательныеПоля.Добавить(
		РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента(НСтр("ru = 'Месяц';
																						|en = 'Month'"), "МесяцНачисленияСтрокой"));
	Описание.ОбязательныеПоля.Добавить(
		РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента(НСтр("ru = 'Организация';
																						|en = 'Company'"), "Объект.Организация"));
	Описание.ОбязательныеПоля.Добавить(
		РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента(НСтр("ru = 'Сотрудник';
																						|en = 'Employee'"), "Объект.Сотрудник"));
	Описание.ОбязательныеПоля.Добавить(
		РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента(НСтр("ru = 'Дата увольнения';
																						|en = 'Date of dismissal'"), "Объект.ДатаУвольнения"));
	
	Если ПризнакКомпенсацииУдержанияОтпуска <> ПредопределенноеЗначение("Перечисление.КомпенсацияУдержаниеОтпускаПриУвольнении.НеИспользовать") Тогда
		Описание.ОбязательныеПоля.Добавить(
			РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеОбязательногоПоляДокумента(НСтр("ru = 'Дней компенсации (удержания) отпуска';
																							|en = 'Days of leave compensation (deduction)'"), "Объект.ДнейКомпенсацииУдержанияОтпуска"));
	КонецЕсли;
	
	Описание.ОписанияТаблицДляРаспределенияРезультата = СтруктураОписанияТаблицДляРаспределенияРезультата(РегистрацияНачисленийДоступна);
	
	Возврат Описание;
	
КонецФункции

Функция СтруктураОписанияТаблицДляРаспределенияРезультата(РегистрацияНачисленийДоступна) Экспорт

	ОписанияТаблиц = Новый Структура;
	ОписанияТаблиц.Вставить("Начисления", ОписаниеТаблицыНачислений(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("НачисленияПерерасчет", ОписаниеТаблицыПерерасчетов(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("Пособия", ОписаниеТаблицыПособия(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("ПособияПерерасчет", ОписаниеТаблицыПособияПерерасчеты(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("Удержания", ОписаниеТаблицыУдержаний(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("НДФЛ", ОписаниеТаблицыНДФЛ(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("КорректировкиВыплаты", ОписаниеТаблицыКорректировкиВыплаты(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("ПогашениеЗаймов", ОписаниеТаблицыПогашениеЗаймов(РегистрацияНачисленийДоступна));
	
	Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.ЛьготыСотрудников") Тогда
		МодульЛьготыСотрудниковКлиентСервер = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("ЛьготыСотрудниковКлиентСервер");
		МодульЛьготыСотрудниковКлиентСервер.ДополнитьСтруктуруОписанийТаблицФормыНачисленияЗарплаты(ОписанияТаблиц, ОписаниеТаблицыЛьгот(РегистрацияНачисленийДоступна));
	КонецЕсли;
	
	Возврат ОписанияТаблиц;

КонецФункции

Функция СтруктураОписанийТаблицДокументаУвольнение(РегистрацияНачисленийДоступна) Экспорт

	ОписанияТаблиц = Новый Структура;
	ОписанияТаблиц.Вставить("Начисления", ОписаниеТаблицыНачислений(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("НачисленияПерерасчет", ОписаниеТаблицыПерерасчетов(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("Пособия", ОписаниеТаблицыПособия(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("ПособияПерерасчет", ОписаниеТаблицыПособияПерерасчеты(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("Удержания", ОписаниеТаблицыУдержаний(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("НДФЛ", ОписаниеТаблицыНДФЛ(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("ПогашениеЗаймов", ОписаниеТаблицыПогашениеЗаймов(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("Льготы", ОписаниеТаблицыЛьгот(РегистрацияНачисленийДоступна));
	ОписанияТаблиц.Вставить("ДенежноеСодержание", ОписаниеТаблицыСохраняемоеДенежноеСодержание());
	ОписанияТаблиц.Вставить("КорректировкиВыплаты", ОписаниеТаблицыКорректировкиВыплаты(РегистрацияНачисленийДоступна));
	
	Если ОбщегоНазначенияБЗККлиентСервер.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.УправленческаяЗарплата") Тогда
		МодульУправленческаяЗарплатаКлиентСервер = ОбщегоНазначенияБЗККлиентСервер.ОбщийМодуль("УправленческаяЗарплатаКлиентСервер");
		МодульУправленческаяЗарплатаКлиентСервер.ПриЗаполненииСтруктурыОписанийТаблицНачисленияЗарплаты(ОписанияТаблиц);
	КонецЕсли;
	
	Возврат ОписанияТаблиц;
	
КонецФункции

#КонецОбласти

#КонецОбласти
