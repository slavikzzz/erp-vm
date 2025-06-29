#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ОбработкаЗаполнения(СообщениеОснование)
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации");
		Организация = Модуль.ОрганизацияПоУмолчанию();
	КонецЕсли;

	ТекущаяДата = ТекущаяДатаСеанса();
	
	Если ВидУслуги = Перечисления.ВидыУслугПриИОН.СведенияОбОтрицательномСальдоЕНС Тогда
		
		ДатаОкончанияПериода = НачалоДня(ТекущаяДатаСеанса());
		ДатаНачалаПериода 	 = ДатаОкончанияПериода;
		
	ИначеЕсли Месяц(ТекущаяДата) < 4 Тогда
		// Предлагаем сделать сверки за предыдущий год
		
		ПрошлыйГод 			 = КонецГода(ДобавитьМесяц(ТекущаяДата, - 12));
		
		ДатаОкончанияПериода = ПрошлыйГод;
		ДатаНачалаПериода 	 = НачалоГода(ДатаОкончанияПериода);
		
	Иначе
		// Предлагаем сделать сверки за текущий год
		
		ДатаОкончанияПериода = ТекущаяДата;
		ДатаНачалаПериода 	 = НачалоГода(ДатаОкончанияПериода);
		
	КонецЕсли;
	
	Если ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеСправкиОбИсполненииОбязанностейПоУплате
		ИЛИ ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов Тогда
		ФорматОтвета = Перечисления.ФорматОтветаНаЗапросИОН.XML;
	Иначе
		ФорматОтвета = ПоследнийИспользуемыйФорматОтвета();
	КонецЕсли;

	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	ЭтоФормат5_07 = ДокументооборотСКОНаВремяВызоваПовтИсп.ЭтоФорматЗапросаИОН5_07();
	
	Если ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов Тогда
		
		Ошибки = Новый Массив;
		Для Каждого СтрокаТаблицы Из ЗапрашиваемыеНалоги Цикл
			
			Если ЗначениеЗаполнено(СтрокаТаблицы.КБК) И СтрДлина(СтрокаТаблицы.КБК) <> 20 Тогда
				
				ТекстСообщения = НСтр("ru = 'Введено некорректное значение КБК %1
                                       |Длина КБК должна быть равна 20 символам';
                                       |en = 'Введено некорректное значение КБК %1
                                       |Длина КБК должна быть равна 20 символам'");
				ТекстСообщения = СтрШаблон(ТекстСообщения, СтрокаТаблицы.КБК);
				Ошибки.Добавить(ТекстСообщения);
				
			ИначеЕсли НЕ ЗначениеЗаполнено(СтрокаТаблицы.КБК) Тогда
				
				ТекстСообщения = НСтр("ru = 'Не заполнен КБК';
										|en = 'Не заполнен КБК'");
				Ошибки.Добавить(ТекстСообщения);
				
			КонецЕсли;
			
		КонецЦикла;
		
		// Вывод полученнных ошибок. Только уникальные ошибки.
		Ошибки = ОбщегоНазначенияКлиентСервер.СвернутьМассив(Ошибки);
		Для каждого Ошибка Из Ошибки Цикл
			
			ОбщегоНазначения.СообщитьПользователю(
				Ошибка, 
				ЭтотОбъект, 
				,
				,
				Отказ);
			
		КонецЦикла; 
		
		НепроверяемыеРеквизиты.Добавить("ЗапрашиваемыеНалоги");
		НепроверяемыеРеквизиты.Добавить("ЗапрашиваемыеНалоги.КБК");
		НепроверяемыеРеквизиты.Добавить("ЗапрашиваемыеНалоги.ОКАТО");
		
	Иначе
		НепроверяемыеРеквизиты.Добавить("ЗапрашиваемыеНалоги");
		НепроверяемыеРеквизиты.Добавить("ЗапрашиваемыеНалоги.КБК");
		НепроверяемыеРеквизиты.Добавить("ЗапрашиваемыеНалоги.ОКАТО");
	КонецЕсли;
	
	НепроверяемыеРеквизиты.Добавить("ДополнительныйПараметр");
	
	ЭтоСправкаОПринадлежности = ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.СправкаОПринадлежностиСумм");
	ЭтоСправкаОПринадлежностиАД = ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.СправкаОПринадлежностиСуммАгрегированныеДанные");
	ЭтоАктСверки = ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов");
	
	ПроверятьПериод = ДокументооборотСКОКлиентСервер.ОбязателенПериодВЗапросеИОН(ЭтотОбъект);
		
	Если НЕ ПроверятьПериод Тогда
			
		НепроверяемыеРеквизиты.Добавить("ДатаНачалаПериода");
		НепроверяемыеРеквизиты.Добавить("ДатаОкончанияПериода");
		
	ИначеЕсли НачалоДня(ДатаОкончанияПериода) < НачалоДня(ДатаНачалаПериода) Тогда
		
		ТекстСообщения = НСтр("ru = 'Дата начала периода должна быть меньше даты окончания периода';
								|en = 'Дата начала периода должна быть меньше даты окончания периода'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаОкончанияПериода",, Отказ);
		
	ИначеЕсли (ЭтоСправкаОПринадлежности ИЛИ ЭтоСправкаОПринадлежностиАД) И Год(ДатаНачалаПериода) < 2023 Тогда
		
		ТекстСообщения = НСтр("ru = 'Согласно п. 1.7 приказа ФНС от 17 марта 2023 г. N ЕД-7-19/173@ при запросе справки о принадлежности сумм начало периода запроса не может быть меньше 01.01.2023';
								|en = 'Согласно п. 1.7 приказа ФНС от 17 марта 2023 г. N ЕД-7-19/173@ при запросе справки о принадлежности сумм начало периода запроса не может быть меньше 01.01.2023'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаНачалаПериода",, Отказ);
		
	ИначеЕсли Год(ДатаОкончанияПериода) <> Год(ДатаНачалаПериода) И ЭтоАктСверки Тогда
		
		ТекстСообщения = НСтр("ru = 'Год начальной и конечной даты периода должен совпадать';
								|en = 'Год начальной и конечной даты периода должен совпадать'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаОкончанияПериода",, Отказ);
		
	ИначеЕсли ЗначениеЗаполнено(ДатаОкончанияПериода) 
		И НачалоДня(ДатаОкончанияПериода) > НачалоДня(ТекущаяДатаСеанса()) Тогда
		
		ТекстСообщения = НСтр("ru = 'Конечная дата периода не должна превышать текущую дату';
								|en = 'Конечная дата периода не должна превышать текущую дату'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДатаОкончанияПериода",, Отказ);
		
	КонецЕсли;
		
	Если (ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов")
		ИЛИ ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.ПредставлениеВыпискиОперацийИзКарточкиРасчетыСБюджетом")
		ИЛИ ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.СправкаОНаличииСальдо") И ДеталСвед)
		И КоличествоНалогов = Перечисления.КоличествоЭлементовДляСверкиИОН.Несколько
		И ЗапрашиваемыеНалоги.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Укажите налоги или КБК, по которым запрашивается сверка';
								|en = 'Укажите налоги или КБК, по которым запрашивается сверка'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ЗапрашиваемыеНалоги",, Отказ);
			
	КонецЕсли;
	
	ЭтоДеталНачСумм = 
		ВидУслуги = ПредопределенноеЗначение("Перечисление.ВидыУслугПриИОН.СправкаОНаличииСальдо") 
		И ДеталНачСумм;
	
	Если ЭтоДеталНачСумм
		И КоличествоКПП <> Перечисления.КоличествоЭлементовДляСверкиИОН.Все
		И ПереченьКПП.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Укажите КПП, по которым запрашивается сверка';
								|en = 'Укажите КПП, по которым запрашивается сверка'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ПереченьКПП",, Отказ);
			
	КонецЕсли;
	
	Если ЭтоДеталНачСумм
		И КоличествоОКТМО <> Перечисления.КоличествоЭлементовДляСверкиИОН.Все
		И ПереченьОКТМО.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Укажите ОКТМО, по которым запрашивается сверка';
								|en = 'Укажите ОКТМО, по которым запрашивается сверка'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ПереченьОКТМО",, Отказ);
			
	КонецЕсли;
	
	Если ЭтоДеталНачСумм
		И (НЕ ЗначениеЗаполнено(ДатаНачалаПериода) ИЛИ НЕ ЗначениеЗаполнено(ДатаОкончанияПериода)) Тогда
		
		ТекстСообщения = НСтр("ru = 'Укажите, за какой квартал детализировать сумму совокупной обязанности';
								|en = 'Укажите, за какой квартал детализировать сумму совокупной обязанности'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДеталНачСумм",, Отказ);
			
	КонецЕсли;
	
	Если ЭтоДеталНачСумм И НЕ ЗначениеЗаполнено(ПрПредДетал) Тогда
		
		ТекстСообщения = НСтр("ru = 'Укажите способ детализации суммы совокупной обязанности ЕНС - по срокам уплаты или по дате учета';
								|en = 'Укажите способ детализации суммы совокупной обязанности ЕНС - по срокам уплаты или по дате учета'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ДеталНачСумм",, Отказ);
			
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ВидУслуги = Перечисления.ВидыУслугПриИОН.СведенияОбОтрицательномСальдоЕНС Тогда
		ДатаНачалаПериода 	 = ДатаОкончанияПериода;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПоследнийИспользуемыйФорматОтвета()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	ЗапросНаИнформационноеОбслуживаниеНалогоплательщика.ФорматОтвета
	|ИЗ
	|	Документ.ЗапросНаИнформационноеОбслуживаниеНалогоплательщика КАК ЗапросНаИнформационноеОбслуживаниеНалогоплательщика
	|ГДЕ
	|	ЗапросНаИнформационноеОбслуживаниеНалогоплательщика.ВидУслуги <> ЗНАЧЕНИЕ(Перечисление.ВидыУслугПриИОН.ПредставлениеСправкиОбИсполненииОбязанностейПоУплате)
	|		И ЗапросНаИнформационноеОбслуживаниеНалогоплательщика.ВидУслуги <> ЗНАЧЕНИЕ(Перечисление.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЗапросНаИнформационноеОбслуживаниеНалогоплательщика.Дата УБЫВ";
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Перечисления.ФорматОтветаНаЗапросИОН.RTF;
	Иначе
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		
		Возврат Выборка.ФорматОтвета;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецЕсли