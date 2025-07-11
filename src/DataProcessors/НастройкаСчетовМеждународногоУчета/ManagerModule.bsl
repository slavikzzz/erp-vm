#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Инициализрует компоновщик настроек запросом-источником заполнения субконто.
// 
// Параметры:
// 	Форма - ФормаКлиентскогоПриложения - Реквизиты формы:
// 		* АдресСхемыКомпоновкиДанных - Строка - 
// 		* КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - 
// 	ИмяРегистра - Строка - 
// 
Процедура ИнициализироватьКомпоновщикНастроек(Форма, ИмяРегистра) Экспорт
	
	СхемаКомпоновкиДанных = КомпоновкаДанныхСервер.ПустаяСхема();
	
	Если ЗначениеЗаполнено(ИмяРегистра) Тогда
		МенеджерРегистра = РегистрыНакопления[ИмяРегистра]; // РегистрНакопленияМенеджер - 
		ПараметрыОтраженияВУчете = МенеджерРегистра.ПараметрыОтраженияДвиженийВФинансовомУчете(); // см. МеждународныйУчетПоДаннымФинансовыхРегистров.ПараметрыОтраженияДвиженийВФинансовомУчете
		НаборДанных = КомпоновкаДанныхСервер.ДобавитьПустойНаборДанных(СхемаКомпоновкиДанных, Тип("НаборДанныхОбъектСхемыКомпоновкиДанных"));
		Для каждого КлючИЗначение Из ПараметрыОтраженияВУчете.ИсточникиСубконто Цикл
			ОписаниеИсточникаСубконто = КлючИЗначение.Значение;
			Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
			Поле.Поле = КлючИЗначение.Ключ;
			Поле.ПутьКДанным = КлючИЗначение.Ключ;
			Поле.Заголовок = ОписаниеИсточникаСубконто.Заголовок;
			Поле.ТипЗначения = ОписаниеИсточникаСубконто.Тип;
		КонецЦикла;
	КонецЕсли;
	
	Форма.АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Форма.УникальныйИдентификатор);
	Форма.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Форма.АдресСхемыКомпоновкиДанных));
	
КонецПроцедуры

// Возвращает структуру отбора настроек заполнения субконто.
// 
// Параметры:
// 	ПланСчетов - СправочникСсылка.ПланыСчетовМеждународногоУчета - План счетов международного учета.
// 	НастройкаФормированияПроводок - СправочникСсылка.НастройкиФормированияПроводокМеждународногоУчета - Настройка формирования проводок.
// 	ОбъектУчета - ПеречислениеСсылка.ОбъектыФинансовогоУчета - Объект финансового учета, по которому получаются используемые счета учета.
// 	СчетУчета - ПланСчетовСсылка.Международный - Счет учета, по которому нужно получить состояние. Если Неопределено, то по всем.
// 
// Возвращаемое значение:
//	Структура - Отбор:
//		* ПланСчетов -  СправочникСсылка.ПланыСчетовМеждународногоУчета -
//		* НастройкаФормированияПроводок - СправочникСсылка.НастройкиФормированияПроводокМеждународногоУчета -
//		* ОбъектУчета - ПеречислениеСсылка.ОбъектыФинансовогоУчета -
//		* СчетУчета - ПланСчетовСсылка.Международный - 
//
Функция ОтборНастроекЗаполненияСубконто(ПланСчетов, НастройкаФормированияПроводок, ОбъектУчета, СчетУчета = Неопределено) Экспорт
	
	Отбор = Новый Структура;
	Отбор.Вставить("ПланСчетов", ПланСчетов);
	Отбор.Вставить("НастройкаФормированияПроводок", НастройкаФормированияПроводок);
	Отбор.Вставить("ОбъектУчета", ОбъектУчета);
	Отбор.Вставить("СчетУчета", СчетУчета);
	
	Возврат Отбор;
	
КонецФункции

// Возвращает настройки заполнения субоконто на счетах на счетах учета.
// 
// Параметры:
// 	Отбор - См. Обработки.НастройкаСчетовМеждународногоУчета.ОтборНастроекЗаполненияСубконто
// 	КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - Необходим для проверки корректности заполнения субконто .
// 	ИспользоватьРучныеНастройки - Булево - Если Ложь, то пользовательские настройки игнорируются.
// 	
// Возвращаемое значение:
// 	ТаблицаЗначений - Таблица состояния настройки:
// 		* СчетУчета - ПланСчетовСсылка.Международный - Счет учета
// 		* ПользовательскаяНастройка - Булево - Признак использования пользовательской настройки заполнения субконто
// 		* ЕстьПроблемыЗаполненияСубконто - Булево - Признак наличия проблем заполнения субконто
// 		
// 		* ВидСубконто1 - ПланВидовХарактеристикСсылка.ВидыСубконтоМеждународные - Вид первого субконто на счете
// 		* ТипЗначенияСубконто1 - ОписаниеТипов - Тип первого субконто на счете
// 		* СпособЗаполненияСубконто1 - ПеречислениеСсылка.СпособыЗаполненияСубконтоМеждународногоУчета - Способ заполнения первого субконто на счете
// 		* ВыражениеЗаполненияСубконто1 - Строка - Если первое субконто заполняется "Из регистра", то выражение для получения значения
// 		* УказанноеЗначениеСубконто1 - СправочникСсылка,
// 		                               ДокументСсылка,
// 		                               ПеречислениеСсылка,
// 		                               ПланВидовХарактеристикСсылка - Если первое субконто заполняется "Из регистра", то выражение для получения значения
// 		* ЕстьПроблемыЗаполненияСубконто1 - Булево - Признак наличия проблем заполнения первого субконто
// 		
// 		* ВидСубконто2 - ПланВидовХарактеристикСсылка.ВидыСубконтоМеждународные - Вид второго субконто на счете
// 		* ТипЗначенияСубконто2 - ОписаниеТипов - Тип второго субконто на счете
// 		* СпособЗаполненияСубконто2 - ПеречислениеСсылка.СпособыЗаполненияСубконтоМеждународногоУчета - Способ заполнения второго субконто на счете
// 		* ВыражениеЗаполненияСубконто2 - Строка - Если второе субконто заполняется "Из регистра", то выражение для получения значения
// 		* УказанноеЗначениеСубконто2 - СправочникСсылка,
// 		                               ДокументСсылка,
// 		                               ПеречислениеСсылка,
// 		                               ПланВидовХарактеристикСсылка - Если второе субконто заполняется "Из регистра", то выражение для получения значения
// 		* ЕстьПроблемыЗаполненияСубконто2 - Булево - Признак наличия проблем заполнения второго субконто
// 		
// 		* ВидСубконто3 - ПланВидовХарактеристикСсылка.ВидыСубконтоМеждународные - Вид третьего субконто на счете
// 		* ТипЗначенияСубконто3 - ОписаниеТипов - Тип третьего субконто на счете
// 		* СпособЗаполненияСубконто3 - ПеречислениеСсылка.СпособыЗаполненияСубконтоМеждународногоУчета - Способ заполнения третьего субконто на счете
// 		* ВыражениеЗаполненияСубконто3 - Строка - Если третье субконто заполняется "Из регистра", то выражение для получения значения
// 		* УказанноеЗначениеСубконто3 - СправочникСсылка,
// 		                               ДокументСсылка,
// 		                               ПеречислениеСсылка,
// 		                               ПланВидовХарактеристикСсылка - Если третье субконто заполняется "Из регистра", то выражение для получения значения
// 		* ЕстьПроблемыЗаполненияСубконто3 - Булево - Признак наличия проблем заполнения третьего субконто
//
Функция НастройкиЗаполненияСубконто(Отбор, КомпоновщикНастроек, ИспользоватьРучныеНастройки = Истина) Экспорт
	
	СостояниеНастройки = Новый ТаблицаЗначений();
	СостояниеНастройки.Колонки.Добавить("СчетУчета", Новый ОписаниеТипов("ПланСчетовСсылка.Международный"));
	СостояниеНастройки.Колонки.Добавить("ПользовательскаяНастройка", Новый ОписаниеТипов("Булево"));
	СостояниеНастройки.Колонки.Добавить("ЕстьПроблемыЗаполненияСубконто", Новый ОписаниеТипов("Булево"));
	
	ОписаниеТиповЗначенийСубконто = Метаданные.ПланыВидовХарактеристик.ВидыСубконтоМеждународные.Тип;
	
	СостояниеНастройки.Колонки.Добавить("ВидСубконто1", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыСубконтоМеждународные"));
	СостояниеНастройки.Колонки.Добавить("ТипЗначенияСубконто1", Новый ОписаниеТипов("ОписаниеТипов"));
	СостояниеНастройки.Колонки.Добавить("СпособЗаполненияСубконто1", Новый ОписаниеТипов("ПеречислениеСсылка.СпособыЗаполненияСубконтоМеждународногоУчета"));
	СостояниеНастройки.Колонки.Добавить("ВыражениеЗаполненияСубконто1", Новый ОписаниеТипов("Строка"));
	СостояниеНастройки.Колонки.Добавить("УказанноеЗначениеСубконто1", ОписаниеТиповЗначенийСубконто);
	СостояниеНастройки.Колонки.Добавить("ЕстьПроблемыЗаполненияСубконто1", Новый ОписаниеТипов("Булево"));
	
	СостояниеНастройки.Колонки.Добавить("ВидСубконто2", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыСубконтоМеждународные"));
	СостояниеНастройки.Колонки.Добавить("ТипЗначенияСубконто2", Новый ОписаниеТипов("ОписаниеТипов"));
	СостояниеНастройки.Колонки.Добавить("СпособЗаполненияСубконто2", Новый ОписаниеТипов("ПеречислениеСсылка.СпособыЗаполненияСубконтоМеждународногоУчета"));
	СостояниеНастройки.Колонки.Добавить("ВыражениеЗаполненияСубконто2", Новый ОписаниеТипов("Строка"));
	СостояниеНастройки.Колонки.Добавить("УказанноеЗначениеСубконто2", ОписаниеТиповЗначенийСубконто);
	СостояниеНастройки.Колонки.Добавить("ЕстьПроблемыЗаполненияСубконто2", Новый ОписаниеТипов("Булево"));
	
	СостояниеНастройки.Колонки.Добавить("ВидСубконто3", Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыСубконтоМеждународные"));
	СостояниеНастройки.Колонки.Добавить("ТипЗначенияСубконто3", Новый ОписаниеТипов("ОписаниеТипов"));
	СостояниеНастройки.Колонки.Добавить("СпособЗаполненияСубконто3", Новый ОписаниеТипов("ПеречислениеСсылка.СпособыЗаполненияСубконтоМеждународногоУчета"));
	СостояниеНастройки.Колонки.Добавить("ВыражениеЗаполненияСубконто3", Новый ОписаниеТипов("Строка"));
	СостояниеНастройки.Колонки.Добавить("УказанноеЗначениеСубконто3", ОписаниеТиповЗначенийСубконто);
	СостояниеНастройки.Колонки.Добавить("ЕстьПроблемыЗаполненияСубконто3", Новый ОписаниеТипов("Булево"));
	
	Если Не ЗначениеЗаполнено(Отбор.ПланСчетов)
		Или Не ЗначениеЗаполнено(Отбор.НастройкаФормированияПроводок)
		Или Не ЗначениеЗаполнено(Отбор.ОбъектУчета) Тогда
		Возврат СостояниеНастройки;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫБОР
	|		КОГДА СрочностьСчетовУчета.Долгосрочный
	|			ТОГДА ПорядокОтражения.СчетУчетаДолгосрочный
	|		ИНАЧЕ ПорядокОтражения.СчетУчета
	|	КОНЕЦ КАК СчетУчета,
	|	ВЫБОР
	|		КОГДА НастройкиЗаполненияСубконто.ВидСубконто1 ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК ПользовательскаяНастройка,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.ВидСубконто1, НЕОПРЕДЕЛЕНО) КАК ВидСубконто1,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.СпособЗаполненияСубконто1, НЕОПРЕДЕЛЕНО) КАК СпособЗаполненияСубконто1,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.ВыражениеЗаполненияСубконто1, НЕОПРЕДЕЛЕНО) КАК ВыражениеЗаполненияСубконто1,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.УказанноеЗначениеСубконто1, НЕОПРЕДЕЛЕНО) КАК УказанноеЗначениеСубконто1,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.ВидСубконто2, НЕОПРЕДЕЛЕНО) КАК ВидСубконто2,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.СпособЗаполненияСубконто2, НЕОПРЕДЕЛЕНО) КАК СпособЗаполненияСубконто2,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.ВыражениеЗаполненияСубконто2, НЕОПРЕДЕЛЕНО) КАК ВыражениеЗаполненияСубконто2,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.УказанноеЗначениеСубконто2, НЕОПРЕДЕЛЕНО) КАК УказанноеЗначениеСубконто2,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.ВидСубконто3, НЕОПРЕДЕЛЕНО) КАК ВидСубконто3,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.СпособЗаполненияСубконто3, НЕОПРЕДЕЛЕНО) КАК СпособЗаполненияСубконто3,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.ВыражениеЗаполненияСубконто3, НЕОПРЕДЕЛЕНО) КАК ВыражениеЗаполненияСубконто3,
	|	ЕСТЬNULL(НастройкиЗаполненияСубконто.УказанноеЗначениеСубконто3, НЕОПРЕДЕЛЕНО) КАК УказанноеЗначениеСубконто3
	|ПОМЕСТИТЬ втНастройкиЗаполненияСубконто
	|ИЗ
	|	РегистрСведений.НастройкиСчетовМеждународногоУчетаПоОбъектам КАК ПорядокОтражения
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.НастройкиЗаполненияСубконтоНаСчетахМеждународногоУчета КАК НастройкиЗаполненияСубконто
	|	ПО
	|		ПорядокОтражения.ПланСчетов = НастройкиЗаполненияСубконто.ПланСчетов
	|		И ПорядокОтражения.НастройкаФормированияПроводок = НастройкиЗаполненияСубконто.НастройкаФормированияПроводок
	|		И ПорядокОтражения.ОбъектУчета = НастройкиЗаполненияСубконто.ОбъектУчета
	|		И ПорядокОтражения.СчетУчета = НастройкиЗаполненияСубконто.СчетУчета
	|		И &ИспользоватьРучныеНастройки
	|	,
	|	(ВЫБРАТЬ
	|		ЛОЖЬ КАК Долгосрочный
	|	ОБЪЕДИНИТЬ ВСЕ
	|	ВЫБРАТЬ
	|		ИСТИНА КАК Долгосрочный
	|	ГДЕ
	|		ИСТИНА В (
	|			ВЫБРАТЬ ПЕРВЫЕ 1
	|				ИСТИНА
	|			ИЗ
	|				Справочник.НастройкиФормированияПроводокМеждународногоУчета КАК НастройкиФормированияПроводок
	|			ГДЕ
	|				НастройкиФормированияПроводок.Ссылка = &НастройкаФормированияПроводок
	|				И НастройкиФормированияПроводок.ИспользоватьВыделениеДолгосрочныхАктивовОбязательств
	|		)
	|	) КАК СрочностьСчетовУчета
	|ГДЕ
	|	ПорядокОтражения.ПланСчетов = &ПланСчетов
	|	И ПорядокОтражения.НастройкаФормированияПроводок = &НастройкаФормированияПроводок
	|	И ПорядокОтражения.ОбъектУчета = &ОбъектУчета
	|	И (&ВсеСчетаУчета
	|		ИЛИ ВЫБОР
	|			КОГДА СрочностьСчетовУчета.Долгосрочный
	|				ТОГДА ПорядокОтражения.СчетУчетаДолгосрочный
	|			ИНАЧЕ ПорядокОтражения.СчетУчета
	|		КОНЕЦ = &СчетУчета)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	СчетУчета
	|;
	|
	|/////////////////////////////////
	|ВЫБРАТЬ
	|	Международный.Ссылка КАК СчетУчета,
	|	ЕСТЬNULL(ВидыСубконто1.ВидСубконто, 
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка)) КАК ВидСубконто1,
	|	ВидыСубконто1.ВидСубконто.ТипЗначения КАК ТипЗначенияСубконто1,
	|	ЕСТЬNULL(ВидыСубконто2.ВидСубконто,
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка)) КАК ВидСубконто2,
	|	ВидыСубконто2.ВидСубконто.ТипЗначения КАК ТипЗначенияСубконто2,
	|	ЕСТЬNULL(ВидыСубконто3.ВидСубконто,
	|		ЗНАЧЕНИЕ(ПланВидовХарактеристик.ВидыСубконтоМеждународные.ПустаяСсылка)) КАК ВидСубконто3,
	|	ВидыСубконто3.ВидСубконто.ТипЗначения КАК ТипЗначенияСубконто3,
	|	втНастройкиЗаполненияСубконто.ПользовательскаяНастройка КАК ПользовательскаяНастройка,
	|	втНастройкиЗаполненияСубконто.ВидСубконто1 КАК ПользовательскаяНастройкаВидСубконто1,
	|	втНастройкиЗаполненияСубконто.СпособЗаполненияСубконто1 КАК СпособЗаполненияСубконто1,
	|	втНастройкиЗаполненияСубконто.ВыражениеЗаполненияСубконто1 КАК ВыражениеЗаполненияСубконто1,
	|	втНастройкиЗаполненияСубконто.УказанноеЗначениеСубконто1 КАК УказанноеЗначениеСубконто1,
	|	втНастройкиЗаполненияСубконто.ВидСубконто2 КАК ПользовательскаяНастройкаВидСубконто2,
	|	втНастройкиЗаполненияСубконто.СпособЗаполненияСубконто2 КАК СпособЗаполненияСубконто2,
	|	втНастройкиЗаполненияСубконто.ВыражениеЗаполненияСубконто2 КАК ВыражениеЗаполненияСубконто2,
	|	втНастройкиЗаполненияСубконто.УказанноеЗначениеСубконто2 КАК УказанноеЗначениеСубконто2,
	|	втНастройкиЗаполненияСубконто.ВидСубконто3 КАК ПользовательскаяНастройкаВидСубконто3,
	|	втНастройкиЗаполненияСубконто.СпособЗаполненияСубконто3 КАК СпособЗаполненияСубконто3,
	|	втНастройкиЗаполненияСубконто.ВыражениеЗаполненияСубконто3 КАК ВыражениеЗаполненияСубконто3,
	|	втНастройкиЗаполненияСубконто.УказанноеЗначениеСубконто3 КАК УказанноеЗначениеСубконто3
	|ИЗ
	|	ПланСчетов.Международный КАК Международный 
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		втНастройкиЗаполненияСубконто КАК втНастройкиЗаполненияСубконто
	|	ПО
	|		Международный.Ссылка = втНастройкиЗаполненияСубконто.СчетУчета
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ПланСчетов.Международный.ВидыСубконто КАК ВидыСубконто1
	|	ПО
	|		Международный.Ссылка = ВидыСубконто1.Ссылка
	|		И ВидыСубконто1.НомерСтроки = 1
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ПланСчетов.Международный.ВидыСубконто КАК ВидыСубконто2
	|	ПО
	|		Международный.Ссылка = ВидыСубконто2.Ссылка
	|		И ВидыСубконто2.НомерСтроки = 2
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ПланСчетов.Международный.ВидыСубконто КАК ВидыСубконто3
	|	ПО
	|		Международный.Ссылка = ВидыСубконто3.Ссылка
	|		И ВидыСубконто3.НомерСтроки = 3
	|ГДЕ
	|	(Международный.Ссылка = &СчетУчета 
	|		ИЛИ &ВсеСчетаУчета)
	|";
	
	Запрос.УстановитьПараметр("ПланСчетов", Отбор.ПланСчетов);
	Запрос.УстановитьПараметр("НастройкаФормированияПроводок", Отбор.НастройкаФормированияПроводок);
	Запрос.УстановитьПараметр("ОбъектУчета", Отбор.ОбъектУчета);
	Запрос.УстановитьПараметр("СчетУчета", Отбор.СчетУчета);
	Запрос.УстановитьПараметр("ВсеСчетаУчета", Не ЗначениеЗаполнено(Отбор.СчетУчета));
	Запрос.УстановитьПараметр("ИспользоватьРучныеНастройки", ИспользоватьРучныеНастройки);
	
	ОписаниеОбъектаУчета = Перечисления.ОбъектыФинансовогоУчета.ОписаниеОбъектаФинансовогоУчета(Отбор.ОбъектУчета);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = СостояниеНастройки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		Если НоваяСтрока.ПользовательскаяНастройка Тогда
			ЗаполнитьСостояниеРучнойНастройкиЗаполненияСубконто(НоваяСтрока, КомпоновщикНастроек);
		Иначе
			ЗаполнитьСостояниеАвтоматическогоЗаполненияСубконто(НоваяСтрока, ОписаниеОбъектаУчета);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СостояниеНастройки;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСостояниеАвтоматическогоЗаполненияСубконто(СтрокаСостоянияНастроек, ОписаниеОбъектаУчета)
	
	Для НомерСубконто = 1 По 3 Цикл
		
		Если НЕ ПустаяСтрока(ОписаниеОбъектаУчета.ИсточникДанных) Тогда
			СтрокаСостоянияНастроек["СпособЗаполненияСубконто" + НомерСубконто] 
				= Перечисления.СпособыЗаполненияСубконтоМеждународногоУчета.ИзРегистра;
		Иначе
			СтрокаСостоянияНастроек["СпособЗаполненияСубконто" + НомерСубконто] 
				= Перечисления.СпособыЗаполненияСубконтоМеждународногоУчета.ИзКорреспонденции;
			Продолжить;
		КонецЕсли;
		
		ТекущийВидСубконто =  СтрокаСостоянияНастроек["ВидСубконто" + НомерСубконто];
		Если Не ЗначениеЗаполнено(ТекущийВидСубконто) Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеТипов = СтрокаСостоянияНастроек["ТипЗначенияСубконто" + НомерСубконто]; // ОписаниеТипов - 
		
		ВозможныеПоля = МеждународныйУчетПоДаннымФинансовыхРегистров.ВозможныеПоляЗаполненияСубконто(ОписаниеТипов, ОписаниеОбъектаУчета);
		Если ВозможныеПоля.Количество() > 0 Тогда
			СтрокаСостоянияНастроек["ВыражениеЗаполненияСубконто" + НомерСубконто] = ВозможныеПоля[0].Значение;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтрокаСостоянияНастроек["ВыражениеЗаполненияСубконто" + НомерСубконто]) Тогда
			СтрокаСостоянияНастроек["ЕстьПроблемыЗаполненияСубконто" + НомерСубконто] = Истина;
			СтрокаСостоянияНастроек["ЕстьПроблемыЗаполненияСубконто"] = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСостояниеРучнойНастройкиЗаполненияСубконто(СтрокаСостоянияНастроек, КомпоновщикНастроек)
	
	Для НомерСубконто = 1 По 3 Цикл
		
		СпособЗаполненияСубконто = СтрокаСостоянияНастроек["СпособЗаполненияСубконто" + НомерСубконто];
		ВыражениеЗаполненияСубконто = СтрокаСостоянияНастроек["ВыражениеЗаполненияСубконто" + НомерСубконто];
		УказанноеЗначениеСубконто = СтрокаСостоянияНастроек["УказанноеЗначениеСубконто" + НомерСубконто];
		
		Если СпособЗаполненияСубконто = Перечисления.СпособыЗаполненияСубконтоМеждународногоУчета.ИзРегистра Тогда
			ПолеКомпоновкиДанных = Новый ПолеКомпоновкиДанных(ВыражениеЗаполненияСубконто);
			ДоступноеПолеВыбора = КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.НайтиПоле(ПолеКомпоновкиДанных);
			Если ДоступноеПолеВыбора = Неопределено Тогда
				// Поля по пути не существует
				СтрокаСостоянияНастроек["ЕстьПроблемыЗаполненияСубконто" + НомерСубконто]  = Истина;
			КонецЕсли;
		ИначеЕсли СпособЗаполненияСубконто = Перечисления.СпособыЗаполненияСубконтоМеждународногоУчета.УказанноеЗначение Тогда
			ОписаниеТиповСубконто = СтрокаСостоянияНастроек["ТипЗначенияСубконто" + НомерСубконто]; // ОписаниеТипов - 
			Если Не ОписаниеТиповСубконто.СодержитТип(ТипЗнч(УказанноеЗначениеСубконто)) Тогда
				// Указанное значение не соотвествует типу субконто.
				СтрокаСостоянияНастроек["ЕстьПроблемыЗаполненияСубконто" + НомерСубконто]  = Истина;
			КонецЕсли;
		КонецЕсли;
		
		Если СтрокаСостоянияНастроек["ЕстьПроблемыЗаполненияСубконто" + НомерСубконто]  Тогда
			СтрокаСостоянияНастроек.ЕстьПроблемыЗаполненияСубконто = Истина;
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры
	
#КонецОбласти

#КонецЕсли
